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
# $env:S3_BUCKET_GALLERY_KEY
# $env:S3_BUCKET_GIT_KEY
# $env:S3_FINAL_BUCKET_NAME
# $env:S3_FINAL_BUCKET_KEY
# $env:TELEGRAM_SECRET

#Requires -Modules @{ModuleName='AWS.Tools.Common';ModuleVersion='4.1.30.0'}
#Requires -Modules @{ModuleName='AWS.Tools.S3';ModuleVersion='4.1.30.0'}
#Requires -Modules @{ModuleName='AWS.Tools.SecretsManager';ModuleVersion='4.1.30.0'}
#Requires -Modules @{ModuleName='Convert';ModuleVersion='0.6.0'}
#Requires -Modules @{ModuleName='PoshGram';ModuleVersion='2.0.0'}

# Uncomment to send the input event to CloudWatch Logs
Write-Host (ConvertTo-Json -InputObject $LambdaInput -Compress -Depth 5)

# SNS -> SQS -> Lambda -> S3
# batch size 10

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

<#
.SYNOPSIS
    Lambda that combines previously created GitHub XML and PSGallery XML into a publicly accessible single XML file.
.DESCRIPTION
    Downloads previously created GitHub XML and PSGallery XML files from S3 locations.
    Loops through and combines the two data sets into a singular XML file and then uploads to publicly accessible S3 bucket.
.OUTPUTS
    S3 x2 to Lambda temp to S3
.COMPONENT
    PSGalleryExplorer
#>

$s3Bucket = $env:S3_BUCKET_NAME
$s3BucketGalleryKey = $env:S3_BUCKET_GALLERY_KEY
$s3BucketGitKey = $env:S3_BUCKET_GIT_KEY
$s3FinalBucket = $env:S3_FINAL_BUCKET_NAME
$s3FinalBucketKey = $env:S3_FINAL_BUCKET_KEY
$script:telegramToken = $null

Write-Host ('Bucket Name: {0}' -f $s3Bucket)
Write-Host ('Bucket Gallery Key: {0}' -f $s3BucketGalleryKey)
Write-Host ('Bucket Git Key: {0}' -f $s3BucketGitKey)
Write-Host ('Final Bucket Name: {0}' -f $s3FinalBucket)
Write-Host ('Final Bucket Key: {0}' -f $s3FinalBucketKey)

#_____________________________________________
$readS3ObjectSplat = @{
    BucketName  = $s3Bucket
    Key         = $s3BucketGalleryKey
    File        = "$env:TEMP/$s3BucketGalleryKey"
    ErrorAction = 'Stop'
}
Write-Host 'Downloading PSGallery XML file...'
try {
    $null = Read-S3Object @readS3ObjectSplat
    Write-Host 'PSGallery download completed.'
}
catch {
    Send-TelegramError -ErrorMessage '\\\ Project PSGalleryExplorer - PubXMLPopulator failed to DL Gallery file.'
    Write-Error $_
    throw
}
Write-Host 'Downloading Git XML file...'
$readS3ObjectSplat = @{
    BucketName  = $s3Bucket
    Key         = $s3BucketGitKey
    File        = "$env:TEMP/$s3BucketGitKey"
    ErrorAction = 'Stop'
}
try {
    $null = Read-S3Object @readS3ObjectSplat
    Write-Host 'Git download completed.'
}
catch {
    Send-TelegramError -ErrorMessage '\\\ Project PSGalleryExplorer - PubXMLPopulator failed to DL Git file.'
    Write-Error $_
    throw
}
#_____________________________________________
Write-Host 'Processing XML conversions...'
$galleryXMLData = Get-Content -Path "$env:TEMP/$s3BucketGalleryKey" -Raw
$galleryData = $galleryXMLData | ConvertFrom-Clixml

$gitXMLData = Get-Content -Path "$env:TEMP/$s3BucketGitKey" -Raw
$gitData = $gitXMLData | ConvertFrom-Clixml
# $galleryData = @()
# $galleryXMLData = Get-Content -Path "$env:TEMP/$s3BucketGalleryKey" -Raw
# $splitup = $galleryXMLData -split '(?<!^)(?=<Objs Version="1.1.0.1" xmlns="http:\/\/schemas.microsoft.com\/powershell\/2004\/04">)'
# foreach ($item in $splitup) {
#     $galleryData += $item | ConvertFrom-Clixml
# }

# $gitData = @()
# $gitXMLData = Get-Content -Path "$env:TEMP/$s3BucketGitKey" -Raw
# $splitupGit = $gitXMLData -split '(?<!^)(?=<Objs Version="1.1.0.1" xmlns="http:\/\/schemas.microsoft.com\/powershell\/2004\/04">)'
# foreach ($item in $splitupGit) {
#     $gitData += $item | ConvertFrom-Clixml
# }
Write-Host 'Conversions completed.'
#_____________________________________________
Write-Host 'Merging Git info into PSGallery...'
foreach ($item in $gitData) {
    $d = $null
    $d = $galleryData | Where-Object { $_.Name -eq $item.Values.ModuleName }

    # $gitHubData = New-Object -TypeName PSObject
    $gitHubData = @{
        GitHubInfo = [ordered]@{
            GitStatus   = $item.Values.GitStatus
            StarCount   = $item.Values.StarCount
            Subscribers = $item.Values.Subscribers
            Watchers    = $item.Values.Watchers
            Created     = $item.Values.Created
            Updated     = $item.Values.Updated
            Forks       = $item.Values.Forks
            License     = $item.Values.License
            Issues      = $item.Values.OpenIssues
        }
    }
    if ($d) {
        $d | Add-Member -NotePropertyMembers $gitHubData -TypeName Asset
    }
}
Write-Host 'Merging completed.'
#_____________________________________________
Write-Host 'Creating output directory.'
$path = "$env:TEMP/XML"
try {
    New-Item -ItemType Directory -Path $path -Force -ErrorAction Stop
}
catch {
    Send-TelegramError -ErrorMessage '\\\ Project PSGalleryExplorer - PubXMLPopulator failed to create output directory.'
    Write-Error $_
    throw
}
Write-Host 'Directory created.'
#_____________________________________________
# accounting for situation where multi-runs might be using same lambda
if (Test-Path "$env:TEMP/$s3FinalBucketKey") {
    Write-Host 'Previous file instance found. Removing...'
    Remove-Item -Path "$env:TEMP/$s3FinalBucketKey" -Force
}
#_____________________________________________
Write-Host 'Converting PSGallery data to XML format...'
$galleryXML = ConvertTo-Clixml -InputObject $galleryData -Depth 100
$galleryXML | Out-File -FilePath "$path/PSGalleryExplorer.xml" -Force -ErrorAction Stop
Write-Host 'XML conversion complete.'
#_____________________________________________
Write-Host 'Compressing XML file to zip...'
try {
    [System.IO.Compression.ZipFile]::CreateFromDirectory("$path", "$env:TEMP/$s3FinalBucketKey")
    # Compress-Archive @compress
    Write-Host 'Compression completed.'
}
catch {
    Send-TelegramError -ErrorMessage '\\\ Project PSGalleryExplorer - PubXMLPopulator failed to compress PSGallery XML data'
    Write-Error $_
    throw
}
#_____________________________________________
Write-Host 'PSGallery data confirmed.'
try {
    Write-Host 'Outputting XML file to public S3 bucket...'
    $s3Splat = @{
        BucketName  = $s3FinalBucket
        Key         = $s3FinalBucketKey
        File        = "$env:TEMP/$s3FinalBucketKey"
        Force       = $true
        ErrorAction = 'Stop'
    }
    Write-S3Object @s3Splat
    Write-Host 'Output to S3 complete.'
}
catch {
    Write-Warning -Message 'An error was encountered outputting raw PSGallery XML file to public S3:'
    Write-Error $_
    Send-TelegramError -ErrorMessage '\\\ Project PSGalleryExplorer - PubXMLPopulator could not output XML to S3 bucket.'
    return
}
#_____________________________________________
