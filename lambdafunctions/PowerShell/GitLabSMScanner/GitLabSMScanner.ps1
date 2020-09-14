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

#Requires -Modules @{ModuleName='AWS.Tools.Common';ModuleVersion='4.1.0.0'}
#Requires -Modules @{ModuleName='AWS.Tools.SecretsManager';ModuleVersion='4.1.0.0'}
#Requires -Modules @{ModuleName='AWS.Tools.S3';ModuleVersion='4.1.0.0'}
#Requires -Modules @{ModuleName='Convert';ModuleVersion='0.4.1'}
#Requires -Modules @{ModuleName='PoshGram';ModuleVersion='1.14.0'}

# State Machine Execution -> Lambda -> S3

# Uncomment to send the input event to CloudWatch Logs
Write-Host (ConvertTo-Json -InputObject $LambdaInput -Compress -Depth 5)

#region supportingFunctions

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
            Write-Host "Secret retrieved."
            $sObj = $script:telegramToken.SecretString | ConvertFrom-Json
            $token = $sObj.TTBotToken
            $channel = $sObj.TTChannel
            Send-TelegramTextMessage -BotToken $token -ChatID $channel -Message $ErrorMessage
        }
    }
    catch {
        Write-Error $_
    }
}#Send-TelegramError

<#
.SYNOPSIS
    Converts GitLab project URI to properly formatted GitLab API URI.
.COMPONENT
    PSGalleryExplorer
#>
function Convert-GitLabProjectURI {
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'GitLab Project URI')]
        [string]
        $URI
    )

    $matchFirstSection = '^https:\/\/gitlab\.com\/'

    $firstSection = [regex]::match($URI, $matchFirstSection).Groups[0].Value
    $lastSection = ($uri -split $firstSection)[1]

    if ($firstSection -and $lastSection) {
        $lastHalfFinal = [uri]::EscapeDataString($lastSection)
        $reconstruct = 'https://gitlab.com/api/v4/projects/' + $lastHalfFinal + '?license=true'
    }

    if ($reconstruct -like "*tree*") {
        $reconstruct = $null
    }

    return $reconstruct
}#Convert-GitLabProjectURI

<#
.SYNOPSIS
    Confirms if URI is properly formatted GitLab API URI.
.COMPONENT
    PSGalleryExplorer
#>
function Confirm-ValidGitLabAPIURL {
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'GitLab Project API URI')]
        [string]
        $URI
    )
    $result = $false #assume the worst
    $criteria = '^https:\/\/gitlab.com\/api\/v4\/projects\/.+%2F.+'
    if ($URI -match $criteria) {
        $result = $true
    }
    return $result
}

<#
.SYNOPSIS
    Queries GitLab API for project information and returns in XML format.
.COMPONENT
    PSGalleryExplorer
#>
function Get-GitLabProjectInfo {
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'PowerShell Module Name')]
        [string]
        $ModuleName,
        [Parameter(Mandatory = $true,
            HelpMessage = 'GitLab Project URI')]
        [string]
        $URI,
        [Parameter(Mandatory = $true,
            HelpMessage = 'GitLab token')]
        [string]
        $Token
    )

    $xml = $null

    $method = 'GET'
    $invokeWebRequestSplat = @{
        Uri                     = $uri
        Headers                 = @{'PRIVATE-TOKEN' = "$token" }
        Method                  = $method
        ContentType             = "application/json"
        ResponseHeadersVariable = 'headerCheck'
        ErrorAction             = 'Stop'
    }

    try {
        $gitlabProjectInfo = Invoke-RestMethod @invokeWebRequestSplat

        #####################################
        $gitLabData = New-Object -TypeName PSObject
        $gitLabData = @{
            GitLabInfo = [ordered]@{
                ModuleName = $ModuleName
                GitStatus  = $true
                StarCount  = $gitlabProjectInfo.star_count
                # Subscribers = $gitlabProjectInfo.subscribers_count
                # Watchers   = $gitlabProjectInfo.watchers
                Created    = $gitlabProjectInfo.created_at
                Updated    = $gitlabProjectInfo.last_activity_at
                Forks      = $gitlabProjectInfo.forks_count
                License    = $gitlabProjectInfo.license.name
                OpenIssues = $gitlabProjectInfo.open_issues_count
            }
        }
        #####################################
        $xml = $gitLabData | ConvertTo-Clixml -Depth 100
        #####################################
        if ($headerCheck.'RateLimit-Remaining' -lt 20) {
            Write-Host "RateLimit-Remaining below 20"
            $script:rateLimit = $true
        }
    }
    catch {
        if ($_.exception.Response.StatusCode -eq 'NotFound') {
            Write-Warning -Message "NOTFOUND: $URI"
            #####################################
            $gitLabData = New-Object -TypeName PSObject
            $gitLabData = @{
                GitLabInfo = [ordered]@{
                    ModuleName = $ModuleName
                    GitStatus  = $false
                }
            }
            #####################################
            $xml = $gitLabData | ConvertTo-Clixml -Depth 100
        }
        elseif ($_.exception.Message -like "*429*") {
            $script:rateLimit = $true
        }
        else {
            Write-Error $_
        }
    }
    return $xml
}#Get-GitLabProjectInfo

#endregion

#region main

<#
.SYNOPSIS
    Lambda that processes calls to GitLab API for each module project URI.
.DESCRIPTION
    Retrieves GitLab token from Secrets Manager.
    Converts module GitLab URI to GitLab API URI.
    Verifies GitLab API URI.
    Check remaining GitLab API calls.
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

Write-Host "Bucket Name: $bucketName"

Write-Host 'Retrieving GitLab token...'
$s = Get-SECSecretValue -SecretId $env:GITHUB_SECRET -Region 'us-west-2' -ErrorAction Stop
if ($null -eq $s) {
    Write-Warning -Message 'Nothing was returned from secrets query'
    throw
}
else {
    Write-Host "Secret retrieved."
    $sObj = $s.SecretString | ConvertFrom-Json
    $token = $sObj.GitLab
}

$gitlabURI = $LambdaInput.GitLabURI
$moduleName = $LambdaInput.ModuleName

Write-Host "GitLab URI: $gitlabURI"
Write-Host "Module Name: $moduleName"

Write-Host 'Converting project URI to API URI...'
$uAPI = Convert-GitLabProjectURI -URI $gitlabURI
Write-Host "API URI: $uAPI"

$uriEval = Confirm-ValidGitLabAPIURL -URI $uAPI

if ($script:rateLimit -eq $true) {
    Write-Host 'API calls still too low after delay...'
    return
}#if_rate_limit
else {
    Write-Host 'Converting project URI to API URI...'
    $uAPI = Convert-GitLabProjectURI -URI $gitlabURI
    Write-Host "API URI: $uAPI"

    if ($null -ne $uAPI) {
        $uriEval = Confirm-ValidGitLabAPIURL -URI $uAPI
        Write-Warning -Message 'URI could not be converted'
    }
    else {
        Write-Host "API URI: $uAPI"
    }

    if ($uriEval -eq $true) {

        Write-Host 'Quering GitLab API for project info...'
        $xml = Get-GitLabProjectInfo -Token $token -ModuleName $moduleName -URI $uAPI
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
                Send-TelegramError -ErrorMessage '\\\ Project PSGalleryExplorer - GitLabScanner could not write XML to S3 bucket.'
                return
            }
        }
        elseif ($null -eq $xml -and $script:rateLimit -eq $true) {
            Write-Host 'API calls still too low after delay...'
            return
        }
        else {
            # reason has already been logged in child function
        }

    }#if_valid_uri
    else {
        Write-Host 'GitLab URI was not use-able for GitLab data query'
    }#else_valid_uri

}##else_rate_limit

#endregion