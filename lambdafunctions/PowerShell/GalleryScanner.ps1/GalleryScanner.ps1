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

# $env:GITHUB_SQS_NAME
# $env:GITLAB_SQS_NAME
# $env:S3_BUCKET_NAME
# $env:S3_KEY_NAME
# $env:TELEGRAM_SECRET

#Requires -Modules @{ModuleName='PackageManagement';ModuleVersion='1.4.7'}
#Requires -Modules @{ModuleName='PowerShellGet';ModuleVersion='2.2.4.1'}
#Requires -Modules @{ModuleName='AWS.Tools.Common';ModuleVersion='4.1.0.0'}
#Requires -Modules @{ModuleName='AWS.Tools.S3';ModuleVersion='4.1.0.0'}
#Requires -Modules @{ModuleName='AWS.Tools.SecretsManager';ModuleVersion='4.1.0.0'}
#Requires -Modules @{ModuleName='AWS.Tools.SQS';ModuleVersion='4.1.0.0'}
#Requires -Modules @{ModuleName='Convert';ModuleVersion='0.4.1'}
#Requires -Modules @{ModuleName='PoshGram';ModuleVersion='1.14.0'}

# Uncomment to send the input event to CloudWatch Logs
Write-Host (ConvertTo-Json -InputObject $LambdaInput -Compress -Depth 5)

# CW Event Scheduled -> Lambda -> SQS

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
}

#endregion

<#
.SYNOPSIS
    Lambda that retrieves all modules from the PSGallery and fans out for GitHub data retrieval.
.DESCRIPTION
    This Lambda serves to retrieve all modules from the PSGallery. Each module is evaluated if it has a corresponding GitHub project. If it does, an SQS message is drafted for GitHub fanout processing.
.OUTPUTS
    XML file to S3
    SQS messages
.NOTES
    # https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-message-attributes.html
    # https://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_SendMessage.html
    # https://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_MessageAttributeValue.html
    # Sample QueueUrl: 'https://sqs.us-west-2.amazonaws.com/AWSAccountId/QueueName'

    MessageAttribute
    MessageAttribute.N.Name (key)
    MessageAttribute.N.Value (value)
        Each message attribute consists of a Name, Type, and Value. For more information, see Amazon SQS Message Attributes in the Amazon Simple Queue Service Developer Guide.
        Type: String to MessageAttributeValue object map
        Required: No
    message_body=message_payload
    message_attributes=message_headers ( can be used to apply different routing and filtering message using their headers information)


    # # messageFormat attribute
    # $formatAttr = New-Object -TypeName Amazon.SQS.Model.MessageAttributeValue
    # $formatAttr.DataType = 'String'
    # $formatAttr.StringValue = 'FORMAT_EMBED'

    # # messageType attribute
    # $typeAttr = New-Object -TypeName Amazon.SQS.Model.MessageAttributeValue
    # $typeAttr.DataType = 'String'
    # $typeAttr.StringValue = $MessageType

    # $msgAttributes = @{
    #     'messageType'   = [Amazon.SQS.Model.MessageAttributeValue]$typeAttr
    #     'messageFormat' = [Amazon.SQS.Model.MessageAttributeValue]$formatAttr
    # }
.COMPONENT
    PSGalleryExplorer
#>

$sqsURLGitHub = $env:GITHUB_SQS_NAME
$sqsURLGitLab = $env:GITLAB_SQS_NAME
$region = $sqsURLGitHub.Split('.')[1]
$bucketName = $env:S3_BUCKET_NAME
$s3Key = $env:S3_KEY_NAME
$script:telegramToken = $null

Write-Host "SQS GITHUB QUEUE URL: $sqsURLGitHub"
Write-Host "SQS GITLAB QUEUE URL: $sqsURLGitHub"
Write-Host "Region: $region"
Write-Host "Bucket Name: $bucketName"
Write-Host "Key Name: $s3Key"

Write-Host 'Retrieving PSGallery module information...'
try {
    $allModules = Find-Module -Name * -Repository PSGallery -ErrorAction Stop
    Write-Host 'PSGallery data retrieval complete.'
}
catch {
    Write-Error $_
}

if ($allModules) {
    Write-Host 'PSGallery data confirmed.'
    $sqsErrors = $false
    try {
        Write-Host 'Converting PSGallery data to XML format...'
        $galleryXML = ConvertTo-Clixml -InputObject $allModules -Depth 100
        $galleryXML | Out-File -FilePath "$env:TEMP/$s3Key" -ErrorAction Stop
        Write-Host 'XML conversion complete.'
        Write-Host 'Outputting XML file to S3 bucket...'
        $s3Splat = @{
            BucketName  = $bucketName
            Key         = $s3Key
            File        = "$env:TEMP/$s3Key"
            Force       = $true
            ErrorAction = 'Stop'
        }
        Write-S3Object @s3Splat
        Write-Host 'Output to S3 complete.'
    }
    catch {
        Write-Warning -Message 'An error was encountered outputting raw PSGallery XML file to S3:'
        Write-Error $_
        Send-TelegramError -ErrorMessage '\\\ Project PSGalleryExplorer - GallerySCanner could not output XML to S3 bucket.'
        return
    }

    $githubCriteria1 = '^http:\/\/github.com'
    $githubCriteria2 = '^http:\/\/www.github.com'
    $githubCriteria3 = '^https:\/\/www.github.com'
    $githubCriteria = '^https:\/\/github.com'
    $gitlabCriteria1 = '^http:\/\/gitlab.com'
    $gitlabCriteria2 = '^http:\/\/www.gitlab.com'
    $gitlabCriteria3 = '^https:\/\/www.gitlab.com'
    $gitlabCriteria = '^https:\/\/gitlab.com'
    foreach ($module in $allModules) {
        #---------------------------
        # resets
        $messageBody = $null
        $sqsSplat = $null
        $moduleURI = $null
        #---------------------------
        $moduleURI = $module.ProjectUri.AbsoluteUri
        #---------------------------
        # github
        if ($moduleURI -match $githubCriteria1) {
            # special case processing - 1
            $moduleURI = $moduleURI.Replace('http:', 'https:')
        }
        elseif ($moduleURI -match $githubCriteria2) {
            # special case processing - 2
            $moduleURI = $moduleURI.Replace('http://www.', 'https://')
        }
        elseif ($moduleURI -match $githubCriteria3) {
            # special case processing - 3
            $moduleURI = $moduleURI.Replace('https://www.', 'https://')
        }
        if ($moduleURI -match $githubCriteria ) {

            $messageBody = ConvertTo-Json -Compress -InputObject @{
                ModuleName = $module.Name
                GitHubURI  = $moduleURI
            }

            $sqsSplat = @{
                MessageBody = $messageBody
                QueueUrl    = $sqsURLGitHub
                Region      = $region
                ErrorAction = 'Stop'
            }

            try {
                Send-SQSMessage @sqsSplat
                Write-Host "Sent an SQS response for $($module.Name)"
            }
            catch {
                Write-Error $_
                $sqsErrors = $true
            }
        }#if_GitHub
        #---------------------------
        # gitlab
        if ($moduleURI -match $gitlabCriteria1) {
            # special case processing - 1
            $moduleURI = $moduleURI.Replace('http:', 'https:')
        }
        elseif ($moduleURI -match $gitlabCriteria2) {
            # special case processing - 2
            $moduleURI = $moduleURI.Replace('http://www.', 'https://')
        }
        elseif ($moduleURI -match $gitlabCriteria3) {
            # special case processing - 3
            $moduleURI = $moduleURI.Replace('https://www.', 'https://')
        }
        if ($moduleURI -match $gitlabCriteria ) {

            $messageBody = ConvertTo-Json -Compress -InputObject @{
                ModuleName = $module.Name
                GitHubURI  = $moduleURI
            }

            $sqsSplat = @{
                MessageBody = $messageBody
                QueueUrl    = $sqsURLGitLab
                Region      = $region
                ErrorAction = 'Stop'
            }

            try {
                Send-SQSMessage @sqsSplat
                Write-Host "Sent an SQS response for $($module.Name)"
            }
            catch {
                Write-Error $_
                $sqsErrors = $true
            }
        }#if_GitLab
        #---------------------------
    }#foreach_module
    if ($sqsErrors -eq $true) {
        Send-TelegramError -ErrorMessage '\\\ Project PSGalleryExplorer - GallerySCanner had issues sending SQS messages.'
    }
    return
}#if_allmodules
else {
    Write-Warning -Message 'No data was returned from Find-Module'
    Send-TelegramError -ErrorMessage '\\\ Project PSGalleryExplorer - GallerySCanner no data was returend from Find-Module.'
    return
}#else_allmodules