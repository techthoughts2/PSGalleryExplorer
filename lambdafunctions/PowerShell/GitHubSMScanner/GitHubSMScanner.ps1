# PowerShell script file to be executed as a AWS Lambda function.
#
# When executing in Lambda the following variables will be predefined.
#   $LambdaInput - A PSObject that contains the Lambda function input data.
#   $LambdaContext - An Amazon.Lambda.Core.ILambdaContext object that contains information about the currently running Lambda environment.
#
# The last item in the PowerShell pipeline will be returned as the result of the Lambda function.
#
# To include PowerShell modules with your Lambda function, like the AWSPowerShell.NetCore module, add a "#Requires" statement
# indicating the module and version.

# $env:S3_BUCKET_NAME
# $env:TELEGRAM_SECRET
# $env:GITHUB_SECRET

#Requires -Modules @{ModuleName='AWS.Tools.Common';ModuleVersion='4.1.30.0'}
#Requires -Modules @{ModuleName='AWS.Tools.SecretsManager';ModuleVersion='4.1.30.0'}
#Requires -Modules @{ModuleName='AWS.Tools.S3';ModuleVersion='4.1.30.0'}
#Requires -Modules @{ModuleName='Convert';ModuleVersion='0.6.0'}
#Requires -Modules @{ModuleName='PoshGram';ModuleVersion='2.0.0'}

# State Machine Execution -> Lambda -> S3

# Uncomment to send the input event to CloudWatch Logs
Write-Host (ConvertTo-Json -InputObject $LambdaInput -Compress -Depth 5)

#region supportingFunctions

<#
.SYNOPSIS
    Determines number of GitHub API calls remaining for API token. 0 is returned if an error is encountered.
.COMPONENT
    PSGalleryExplorer
.LINK
    https://developer.github.com/
.LINK
    https://developer.github.com/v3/#rate-limiting
.LINK
    https://developer.github.com/v3/rate_limit/
#>
function Test-GitHubRateLimit {
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'GitHub Oauth token')]
        [string]
        $Token
    )
    $rateLimit = 'https://api.github.com/rate_limit'
    $invokeWebRequestSplat = @{
        Uri         = $rateLimit
        Headers     = @{Authorization = "Bearer $Token" }
        # Method = $method
        ContentType = 'application/json'
        ErrorAction = 'Stop'
    }

    $remaining = 0 #assume the worst
    try {
        $rl2 = Invoke-RestMethod @invokeWebRequestSplat
        $remaining = $rl2.rate.remaining
    }
    catch {
        Write-Warning -Message 'An error was encountered checking GitHub rate_limit:'
        Write-Warning $_
    }

    return $remaining
} #Test-GitHubRateLimit

<#
.SYNOPSIS
    Queries GitHub API for project information and returns in XML format.
.COMPONENT
    PSGalleryExplorer
#>
function Get-GitHubProjectInfo {
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'PowerShell Module Name')]
        [string]
        $ModuleName,
        [Parameter(Mandatory = $true,
            HelpMessage = 'GitHub Project URI')]
        [string]
        $URI,
        [Parameter(Mandatory = $true,
            HelpMessage = 'GitHub Oauth token')]
        [string]
        $Token
    )

    $xml = $null

    $invokeWebRequestSplat = @{
        Uri         = $uri
        Headers     = @{Authorization = "Bearer $token" }
        # Method = $method
        ContentType = 'application/json'
        ErrorAction = 'Stop'
    }
    try {
        $githubProjectInfo = Invoke-RestMethod @invokeWebRequestSplat

        #####################################
        $gitHubData = New-Object -TypeName PSObject
        $gitHubData = @{
            GitHubInfo = [ordered]@{
                ModuleName  = $ModuleName
                GitStatus   = $true
                StarCount   = $githubProjectInfo.stargazers_count
                Subscribers = $githubProjectInfo.subscribers_count
                Watchers    = $githubProjectInfo.watchers
                Created     = $githubProjectInfo.created_at
                Updated     = $githubProjectInfo.updated_at
                Forks       = $githubProjectInfo.forks_count
                License     = $githubProjectInfo.license.name
                OpenIssues  = $githubProjectInfo.open_issues_count
            }
        }
        #####################################
        $xml = $gitHubData | ConvertTo-Clixml -Depth 100
    }
    catch {
        if ($_.exception.Response.StatusCode -eq 'NotFound') {
            Write-Warning -Message ('NOT FOUND: {0}' -f $URI)
            #####################################
            $gitHubData = New-Object -TypeName PSObject
            $gitHubData = @{
                GitHubInfo = [ordered]@{
                    ModuleName = $ModuleName
                    GitStatus  = $false
                }
            }
            #####################################
            $xml = $gitHubData | ConvertTo-Clixml -Depth 100
        }
        else {
            Write-Error $_
        }
    }
    return $xml
} #Get-GitHubProjectInfo

<#
.SYNOPSIS
    Converts GitHub project URI to properly formatted GitHub API URI.
.COMPONENT
    PSGalleryExplorer
#>
function Convert-GitHubProjectURI {
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'GitHub Project URI')]
        [string]
        $URI
    )
    $split = $URI.Split("/")
    $reconstruct = 'https://api.github.com/repos/' + $split[3] + "/" + $split[4]
    if ($reconstruct -match '^https:\/\/api.github.com\/repos\/.+\/.+\.git') {
        $reconstruct = $reconstruct.Substring(0, $reconstruct.Length - 4)
    }
    return $reconstruct
}

<#
.SYNOPSIS
    Confirms if URI is properly formatted GitHub API URI.
.COMPONENT
    PSGalleryExplorer
#>
function Confirm-ValidGitHubAPIURL {
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'GitHub Project API URI')]
        [string]
        $URI
    )
    $result = $false #assume the worst
    $criteria = '^https:\/\/api.github.com\/repos\/.+\/.+'
    if ($URI -match $criteria) {
        $result = $true
    }
    return $result
}

<#
.SYNOPSIS
    Sends error message to Telegram for notification.
.COMPONENT
    PSGalleryExplorer
#>
function Send-TelegramError {
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Original File Path')]
        [string]
        $ErrorMessage
    )
    if ($null -eq $script:telegramToken ) {
        $script:telegramToken = Get-SECSecretValue -SecretId $env:TELEGRAM_SECRET -Region 'us-west-2' -ErrorAction Stop
    }
    try {
        if ($null -eq $script:telegramToken ) {
            Write-Warning -Message 'Nothing was returned from secrets query'
        }
        else {
            Write-Host 'Secret retrieved.'
            $sObj = $script:telegramToken.SecretString | ConvertFrom-Json
            $token = $sObj.TTBotToken
            $channel = $sObj.TTChannel
            Send-TelegramTextMessage -BotToken $token -ChatID $channel -Message $ErrorMessage
        }
    }
    catch {
        Write-Error $_
    }
}

#endregion

#region main

<#
.SYNOPSIS
    Lambda that processes calls to GitHub API for each module project URI.
.DESCRIPTION
    Retrieves GitHub Oauth token from Secrets Manager.
    Converts module GitHub URI to GitHub API URI.
    Verifies GitHub API URI.
    Check remaining GitHub API calls.
    If API calls remaining is not too low it will process the API call to retrieve project information and save to S3 in XML format.
    If API calls are too low it will trigger a State Machine to try again later.
.OUTPUTS
    XML to S3 Bucket
    -or-
    State Machine Trigger
.COMPONENT
    PSGalleryExplorer
#>

$bucketName = $env:S3_BUCKET_NAME
$script:telegramToken = $null

Write-Host ('Bucket Name: {0}' -f $bucketName)

Write-Host 'Retrieving GitHub Oauth token...'
$s = Get-SECSecretValue -SecretId $env:GITHUB_SECRET -Region 'us-west-2' -ErrorAction Stop
if ($null -eq $s) {
    Write-Warning -Message 'Nothing was returned from secrets query'
    throw
}
else {
    Write-Host 'Secret retrieved.'
    $sObj = $s.SecretString | ConvertFrom-Json
    $token = $sObj.GitHub
}

Write-Host 'Determining number of remaining GitHub API calls...'
$remaining = Test-GitHubRateLimit -Token $token
Write-Host ('Remaining GitHub limit: {0}' -f $remaining)

$githubURI = $LambdaInput.GitHubURI
$moduleName = $LambdaInput.ModuleName

Write-Host ('GitHub URI: {0}' -f $githubURI)
Write-Host ('Module Name: {0}' -f $moduleName)

Write-Host 'Converting project URI to API URI...'
$uAPI = Convert-GitHubProjectURI -URI $githubURI

if ($null -ne $uAPI) {
    $uriEval = Confirm-ValidGitHubAPIURL -URI $uAPI
    Write-Host ('API URI: {0}' -f $uAPI)
}
else {
    Write-Warning -Message 'URI could not be converted'
}

if ($uriEval -eq $true) {
    if ($remaining -le 50) {
        Write-Host 'API calls still too low after delay...'
        return
    } #if_API_lt_300
    else {
        Write-Host 'Querying GitHub API for project info...'
        $xml = Get-GitHubProjectInfo -Token $token -ModuleName $moduleName -URI $uAPI
        if ($xml) {
            Write-Host 'Outputting XML file to S3 bucket...'
            try {
                $xml | Out-File -FilePath "$env:TEMP/$moduleName.xml" -ErrorAction Stop
                $s3Splat = @{
                    BucketName  = $bucketName
                    Key         = "$moduleName.xml"
                    File        = "$env:TEMP/$moduleName.xml"
                    Force       = $true
                    ErrorAction = 'Stop'
                }
                Write-S3Object @s3Splat
                Remove-Item -Path "$env:TEMP/$moduleName.xml" -Force
                Write-Host 'Output to S3 complete.'
            }
            catch {
                Write-Warning -Message 'An error was encountered outputting raw PSGallery XML file to S3:'
                Write-Error $_
                Send-TelegramError -ErrorMessage '\\\ Project PSGalleryExplorer - GitHubSMScanner could not output XML to S3 bucket.'
                return
            }
        }
        else {
            Write-Warning -Message 'No data was returned from GitHub query.'
        }
    } #else_API_lt_300
} #if_valid_uri
else {
    Write-Host 'GitHub URI was not use-able for GitHub data query'
} #else_valid_uri

#endregion
