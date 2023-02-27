# PowerShell script file to be executed as an AWS Lambda function.
#
# When executing in Lambda the following variables will be predefined.
#   $LambdaInput - A PSObject that contains the Lambda function input data.
#   $LambdaContext - An Amazon.Lambda.Core.ILambdaContext object that contains information about the currently running Lambda environment.
#
# The last item in the PowerShell pipeline will be returned as the result of the Lambda function.
#
# To include PowerShell modules with your Lambda function, like the AWS.Tools.Common module, add a "#Requires" statement
# indicating the module and version.

# Env variables that are set by the AWS Lambda environment:
# $env:S3_BUCKET_NAME
# $env:TELEGRAM_SECRET
# $env:SERVICE_NAME

#Requires -Modules @{ModuleName='AWS.Tools.Common';ModuleVersion='4.1.275'}
#Requires -Modules @{ModuleName='AWS.Tools.CloudWatch';ModuleVersion='4.1.275'}
#Requires -Modules @{ModuleName='AWS.Tools.SimpleSystemsManagement';ModuleVersion='4.1.275'}
#Requires -Modules @{ModuleName='AWS.Tools.S3';ModuleVersion='4.1.275'}
#Requires -Modules @{ModuleName='PoshGram';ModuleVersion='2.3.0'}

# Uncomment to send the input event to CloudWatch Logs
Write-Host (ConvertTo-Json -InputObject $LambdaInput -Compress -Depth 5)

# CW Event Scheduled -> Lambda -> CW Metric

#region supportingFunctions

function Send-TelegramMessage {
    <#
    .SYNOPSIS
        Sends message to Telegram for notification.
    #>
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Message to send to telegram')]
        [string]
        $Message
    )

    if ($null -eq $script:telegramToken -or $null -eq $script:telegramChannel) {
        try {
            $getSSMParameterValueSplatToken = @{
                Name           = 'telegramtoken'
                WithDecryption = $true
                ErrorAction    = 'Stop'
            }
            $getSSMParameterValueSplatChannel = @{
                Name           = 'telegramchannel'
                WithDecryption = $true
                ErrorAction    = 'Stop'
            }
            $script:telegramToken = Get-SSMParameterValue @getSSMParameterValueSplatToken
            $script:telegramChannel = Get-SSMParameterValue @getSSMParameterValueSplatChannel
        }
        catch {
            throw $_
        }
    } #if_token_channel_null

    if ([string]::IsNullOrWhiteSpace($script:telegramToken) -or [string]::IsNullOrWhiteSpace($script:telegramChannel)) {
        throw 'Parameters not successfully retrieved'
    }
    else {
        Write-Host 'Parameters retrieved.'
        $token = $script:telegramToken.Parameters.Value
        $channel = $script:telegramChannel.Parameters.Value
        $out = Send-TelegramTextMessage -BotToken $token -ChatID $channel -Message $Message
        Write-Host ($out | Out-String)
    }
} #Send-TelegramMessage

#endregion

$key = '{0}.zip' -f $env:SERVICE_NAME
Write-Host ('Retrieving {0} from {1}..' -f $key, $env:S3_BUCKET_NAME)
try {
    $getS3ObjectSplat = @{
        BucketName  = $env:S3_BUCKET_NAME
        Key         = $key
        ErrorAction = 'Stop'
    }
    $objInfo = Get-S3Object @getS3ObjectSplat
}
catch {
    Write-Warning -Message 'Error retrieving object from S3'
    Write-Error $_
    Send-TelegramMessage -Message '\\\ Project PSGalleryExplorer - PubXMLMonitor Error retrieving object from S3'
    return
}

if ($null -eq $objInfo) {
    Write-Warning -Message 'No object returned from S3'
    Send-TelegramMessage -Message '\\\ Project PSGalleryExplorer - PubXMLMonitor The S3 object was not found'
}

Write-Host 'Getting current date'
$now = Get-Date

Write-Host 'Determining how old the object is'
$diff = $now - $objInfo.LastModified
$diffDays = $diff.Days
Write-Host ('Object is {0} days old' -f $diffDays)

# Create a MetricDatum .NET object
$MetricDatum = [Amazon.CloudWatch.Model.MetricDatum]::new()
$MetricDatum.MetricName = 'PubXMLAge'
$MetricDatum.Value = $diffDays

# Create a Dimension .NET object
$Dimension = [Amazon.CloudWatch.Model.Dimension]::new()
$Dimension.Name = 'PubXML'
$Dimension.Value = 'DaysOld'

# Assign the Dimension object to the MetricDatum's Dimensions property
$MetricDatum.Dimensions = $Dimension

$Namespace = 'PSGalleryExplorer'

try {

    # Write the metric data to the CloudWatch service
    $writeCWMetricDataSplat = @{
        Namespace   = $Namespace
        MetricData  = $MetricDatum
        ErrorAction = 'Stop'
    }
    Write-CWMetricData @writeCWMetricDataSplat
}
catch {
    $errorMessage = $_.Exception.Message
    Write-Error -Message ('Something went wrong: {0}' -f $errorMessage)
    Send-TelegramMessage -Message '\\\ Project PSGalleryExplorer - PubXMLMonitor Error sending metric data to CloudWatch'
}

return $true
