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

#Requires -Modules @{ModuleName='AWS.Tools.Common';ModuleVersion='4.0.2.0'}
#Requires -Modules @{ModuleName='AWS.Tools.S3';ModuleVersion='4.0.2.0'}
#Requires -Modules @{ModuleName='AWS.Tools.SecretsManager';ModuleVersion='4.0.2.0'}
#Requires -Modules @{ModuleName='Convert';ModuleVersion='0.4.1'}
#Requires -Modules @{ModuleName='PoshGram';ModuleVersion='1.10.1'}

# Uncomment to send the input event to CloudWatch Logs
Write-Host (ConvertTo-Json -InputObject $LambdaInput -Compress -Depth 5)

# CW Event Scheduled -> Lambda -> S3

#region supportingFunctions

<#
.SYNOPSIS
    Compares files hashes of two provided file paths.
.COMPONENT
    PSGalleryExplorer
#>
function Test-HashValues {
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Original File Path')]
        [string]
        $orgPath,
        [Parameter(Mandatory = $true,
            HelpMessage = 'New File Path')]
        [string]
        $newPath
    )
    $match = $false # assume no match
    $a = Get-FileHash -Path $orgPath
    $b = Get-FileHash -Path $newPath
    if ($a.Hash -eq $b.Hash) {
        $match = $true
    }
    return $match
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
        $script:token = Get-SECSecretValue -SecretId PoshGramTokens -Region us-west-2 -ErrorAction Stop
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

<#
.SYNOPSIS
    Lambda that combines GitHub project XMLs into a singular XML.
.DESCRIPTION
    This Lambda serves to download previously created GitHub project XMLs and combine them into a singular XML file which is then uploaded to S3.
.OUTPUTS
    S3 to Lambda temp to S3
.COMPONENT
    PSGalleryExplorer
#>

$gitXMLBucket = $env:GIT_S3_BUCKET_NAME
$destXMLBucket = $env:S3_BUCKET_NAME
$fKey = $env:S3_KEY_NAME
$script:token = $null

Write-Host "Git XML Bucket Name: $gitXMLBucket"
Write-Host "Bucket Name: $destXMLBucket"
Write-Host "Key: $fKey"

Write-Host "Retrieving all raw XML GitHub files..."

try {
    $gitXMLFileInfo = Get-S3Object -BucketName $gitXMLBucket -ErrorAction Stop
    Write-Host "List of files retrieved."
}
catch {
    Write-Error $_
    throw
}

if ($gitXMLFileInfo) {
    #_____________________________________________
    Write-Host 'Creating output directory.'
    $path = "$env:TEMP/XMLs"
    try {
        New-Item -ItemType Directory -Path $path -Force -ErrorAction Stop
    }
    catch {
        Send-TelegramError -ErrorMessage '\\\ Project PSGalleryExplorer - GCombine failed to create output directory.'
        Write-Error $_
        throw
    }
    #_____________________________________________
    Write-Host "Downloading all files..."
    foreach ($file in $gitXMLFileInfo) {
        $readS3ObjectSplat = @{
            BucketName  = $gitXMLBucket
            Key         = $file.Key
            File        = "$path/$($file.Key)"
            ErrorAction = 'Stop'
        }
        try {
            $null = Read-S3Object @readS3ObjectSplat
        }
        catch {
            Send-TelegramError -ErrorMessage '\\\ Project PSGalleryExplorer - GCombine failed to DL files from gitXMLBucket'
            Write-Error $_
            throw
        }
    }
    Write-Host "Download completed."
    #_____________________________________________
    Write-Host "Combining all file contents into memory..."
    try {
        $allXMLFiles = Get-ChildItem -Path $path -ErrorAction Stop
    }
    catch {
        Send-TelegramError -ErrorMessage '\\\ Project PSGalleryExplorer - GCombine failed to load XML file contents into memory.'
        Write-Error $_
        throw
    }
    $xmlData = @()
    foreach ($file in $allXMLFiles) {
        $temp = $null
        $temp = Get-Content -Path $file.FullName -Raw
        $xmlData += $temp | ConvertFrom-Clixml
    }
    Write-Host "Combining process completed."
    #_____________________________________________
    Write-Host "Output final XML file to disk..."
    $finalXML = $xmlData | ConvertTo-Clixml
    $finalXML | Out-File -FilePath "$env:TEMP/$fKey"
    Write-Host "Disk output completed."
    #_____________________________________________
    Write-Host "Downloading original file..."
    $readS3ObjectSplat = @{
        BucketName  = $destXMLBucket
        Key         = $fKey
        File        = "$env:TEMP/original.xml"
        ErrorAction = 'Stop'
    }
    try {
        $null = Read-S3Object @readS3ObjectSplat
    }
    catch {
        Send-TelegramError -ErrorMessage '\\\ Project PSGalleryExplorer - GCombine failed to DL original S3 XML file.'
        Write-Error $_
    }
    Write-Host "Downloading completed."
    #_____________________________________________
    $dlEval = Test-Path "$env:TEMP/original.xml"
    #_____________________________________________
    Write-Host "Comparing hash of two files..."
    if ($dlEval -eq $true) {
        $hashComparison = Test-HashValues -orgPath "$env:TEMP/$fKey" -newPath "$env:TEMP/original.xml"
    }
    else {
        $hashComparison = $false
    }
    Write-Host "Hash Comparison: $hashComparison"
    #_____________________________________________
    if ($hashComparison -eq $false) {
        Write-Host 'Outputting XML file to S3 bucket...'
        $s3Splat = @{
            BucketName  = $destXMLBucket
            Key         = $fKey
            File        = "$env:TEMP/$fKey"
            Force       = $true
            ErrorAction = 'Stop'
        }
        Write-S3Object @s3Splat
        Write-Host 'Output to S3 complete.'
    }
    else {
        Write-Host 'Hash match. No further action taken.'
    }
}#if_gitXMLFileInfo
else {
    Write-Warning -Message 'No XML files were discovered in the bucket.'
    Send-TelegramError -ErrorMessage '\\\ Project PSGalleryExplorer - GCombine did not find any XML files in the GitXML bucket.'
    throw
}#gitXMLFileInfo