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

# $env:STATE_MACHINE_NAME
# $env:STATE_MACHINE_ARN
# $env:S3_BUCKET_NAME
# $env:TELEGRAM_SECRET
# $env:GITHUB_SECRET

#Requires -Modules @{ModuleName='AWS.Tools.Common';ModuleVersion='4.1.0.0'}
#Requires -Modules @{ModuleName='AWS.Tools.SecretsManager';ModuleVersion='4.1.0.0'}
#Requires -Modules @{ModuleName='AWS.Tools.S3';ModuleVersion='4.1.0.0'}
#Requires -Modules @{ModuleName='AWS.Tools.StepFunctions';ModuleVersion='4.1.0.0'}
#Requires -Modules @{ModuleName='Convert';ModuleVersion='0.4.1'}
#Requires -Modules @{ModuleName='PoshGram';ModuleVersion='1.14.0'}

# SQS -> Lambda -> S3
#  -or-
# SQS -> Lambda -> State Machine Execution

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
        ContentType = "application/json"
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
}#Test-GitHubRateLimit

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
        ContentType = "application/json"
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
            }
        }
        #####################################
        $xml = $gitHubData | ConvertTo-Clixml -Depth 100
    }
    catch {
        if ($_.exception.Response.StatusCode -eq 'NotFound') {
            Write-Warning -Message "NOTFOUND: $URI"
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
}#Get-GitHubProjectInfo

<#
.SYNOPSIS
    Triggers specified State Machine.
.COMPONENT
    PSGalleryExplorer
#>
function Start-StateMExecution {
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'JSON Message with Module info')]
        [string]
        $MessageJSON,
        [Parameter(Mandatory = $true,
            HelpMessage = 'Arn of target State Machine')]
        [string]
        $StateMachineArn,
        [Parameter(Mandatory = $true,
            HelpMessage = 'Name of target State Macine')]
        [string]
        $StateMachineName
    )

    # Invoke the State Machine
    $startSFNExecution = @{
        StateMachineArn = $StateMachineArn
        Input           = $MessageJSON
        ErrorAction     = 'Stop'
    }
    try {
        $sfnExecution = Start-SFNExecution @startSFNExecution
    }
    catch {
        $message = 'Exception caught calling Start-SFNExecution. {0}' -f $_.Exception.Message
        Write-Warning -Message $message
        throw
    }

    # Write log entry of what was invoked.
    # $StateMachineName = $env:StateMachineArn.Split(':')[-1]
    Write-Host (ConvertTo-Json -Compress -InputObject @{
            StateMachineName = $StateMachineName
            ExecutionArn     = $sfnExecution.ExecutionArn
        })
}#Start-StateMExecution

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
    if ($null -eq $script:token ) {
        $script:token = Get-SECSecretValue -SecretId $env:TELEGRAM_SECRET -Region 'us-west-2' -ErrorAction Stop
    }
    try {
        if ($null -eq $script:token ) {
            Write-Warning -Message 'Nothing was returned from secrets query'
        }
        else {
            Write-Host "Secret retrieved."
            $sObj = $script:token.SecretString | ConvertFrom-Json
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
.LINK
    https://developer.github.com/
.LINK
    https://developer.github.com/v3/#rate-limiting
.LINK
    https://developer.github.com/v3/rate_limit/
#>

$y = 'https://api.github.com/repos/qbikez/ps-entropy.git'
$y = 'https://api.github.com/repos/techthoughts2/PoshGram'
$s = $y.Substring(0, $y.lastIndexOf('.git'))
'https://api.github.com/repos/dfensgmbh/biz.dfch.PS.Activiti.Client.git'


#handle not found differently
#check for null json value before sending message
<#

message	"Not Found"
documentation_url	"https://developer.github.com/v3/repos/#get"
#>

$stateMachineName = $env:STATE_MACHINE_NAME
$stateMachineNameArn = $env:STATE_MACHINE_ARN
$bucketName = $env:S3_BUCKET_NAME
$script:token = $null

Write-Host "State Machine Name: $stateMachineName"
Write-Host "State Machine Arn: $stateMachineNameArn"
Write-Host "Bucket Name: $bucketName"

Write-Host 'Retrieving GitHub Oauth token...'
$s = Get-SECSecretValue -SecretId $env:GITHUB_SECRET -Region 'us-west-2' -ErrorAction Stop
if ($null -eq $s) {
    Write-Warning -Message 'Nothing was returned from secrets query'
    throw
}
else {
    Write-Host "Secret retrieved."
    $sObj = $s.SecretString | ConvertFrom-Json
    $token = $sObj.GitHub
}

Write-Host "Determing number of remaining GitHub API calls..."
$remaining = Test-GitHubRateLimit -Token $token
Write-Host "Remaining GitHub limit: $remaining"

foreach ($message in $LambdaInput.Records) {

    Write-Host $message.body

    #___________________
    # resets
    $messageData = $null
    $githubURI = $null
    $moduleName = $null
    $uAPI = $null
    $xml = $null
    $uriEval = $false
    #___________________

    $messageData = $message.body | ConvertFrom-Json
    $githubURI = $messageData.GitHubURI
    $moduleName = $messageData.ModuleName

    $startStateMExecutionSplat = @{
        StateMachineName = $stateMachineName
        StateMachineArn  = $stateMachineNameArn
        MessageJSON      = $message.body
    }

    Write-Host 'Converting project URI to API URI...'
    $uAPI = Convert-GitHubProjectURI -URI $githubURI
    Write-Host "API URI: $uAPI"

    $uriEval = Confirm-ValidGitHubAPIURL -URI $uAPI

    if ($uriEval -eq $true) {
        if ($remaining -le 300) {
            Write-Host 'API calls low... triggering State Machine delay...'
            Start-StateMExecution @startStateMExecutionSplat
            Start-Sleep -Milliseconds (20)
        }#if_API_lt_300
        else {
            Write-Host 'Quering GitHub API for project info...'
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
                    Send-TelegramError -ErrorMessage '\\\ Project PSGalleryExplorer - GitHubScanner could not write XML to S3 bucket.'
                    return
                }
            }
            else {
                # reason has already been logged in child function
            }
        }#else_API_lt_300
    }#if_valid_uri
    else {
        Write-Host 'GitHub URI was not use-able for GitHub data query'
    }#else_valid_uri
}#foreach_SQS

#endregion