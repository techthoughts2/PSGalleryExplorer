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

$script:rateLimit = $false

<#
GitLab.com responds with HTTP status code 429 to API requests that exceed 10 requests per second per IP address.
RateLimit-Limit: 600
RateLimit-Observed: 6
RateLimit-Remaining: 594
RateLimit-Reset: 1563325137
RateLimit-ResetTime: Wed, 17 Jul 2019 00:58:57 GMT

Response status code does not indicate success: 429 (Too Many Requests).
#>

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
    Performs checks to stay within rate limit of GitLab API calls.
    If API calls remaining is not too low it will process the API call to retrieve project information and save to S3 in XML format.
    If API calls are too low it will trigger a State Machine to try again later.
.OUTPUTS
    XML to S3 Bucket
    -or-
    State Machine Trigger
.COMPONENT
    PSGalleryExplorer
.LINK
    https://docs.gitlab.com/ee/api/README.html
.LINK
    https://docs.gitlab.com/ee/api/README.html#rate-limits
.LINK
    https://docs.gitlab.com/ee/api/README.html#namespaced-path-encoding
.LINK
    https://docs.gitlab.com/ee/api/README.html#personalproject-access-tokens
.LINK
    https://docs.gitlab.com/ee/api/projects.html#get-single-project
.LINK
    https://docs.gitlab.com/ee/user/gitlab_com/index.html#haproxy-api-throttle
#>

$stateMachineName = $env:STATE_MACHINE_NAME
$stateMachineNameArn = $env:STATE_MACHINE_ARN
$bucketName = $env:S3_BUCKET_NAME
$script:telegramToken = $null

Write-Host "State Machine Name: $stateMachineName"
Write-Host "State Machine Arn: $stateMachineNameArn"
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

foreach ($message in $LambdaInput.Records) {

    Write-Host $message.body

    #___________________
    # resets
    $messageData = $null
    $gitlabURI = $null
    $moduleName = $null
    $uAPI = $null
    $xml = $null
    $uriEval = $false
    #___________________

    $messageData = $message.body | ConvertFrom-Json
    $gitlabURI = $messageData.GitLabURI
    $moduleName = $messageData.ModuleName

    # #############testing DELETE
    # $gitlabURI = 'https://gitlab.com/Valtech-Amsterdam/PowerShell/WakeUpAzureWebApp'
    # $moduleName = 'WakeUpAzureWebApp'
    # ##########################

    $startStateMExecutionSplat = @{
        StateMachineName = $stateMachineName
        StateMachineArn  = $stateMachineNameArn
        MessageJSON      = $message.body
    }

    if ($script:rateLimit -eq $true) {
        Write-Host 'API calls low... triggering State Machine delay...'
        Start-StateMExecution @startStateMExecutionSplat
        Start-Sleep -Milliseconds (20)
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
                # condition here is that most likely an exception was thrown in retrieval
                # if an exception was thrown and evaled to ratelimit true, we will trigger the state machine
                Write-Host 'API calls low... triggering State Machine delay...'
                Start-StateMExecution @startStateMExecutionSplat
                Start-Sleep -Milliseconds (20)
            }
            else {
                # reason has already been logged in child function
            }

        }#if_valid_uri
        else {
            Write-Host 'GitLab URI was not use-able for GitLab data query'
        }#else_valid_uri

    }##else_rate_limit
}#foreach_SQS

#endregion