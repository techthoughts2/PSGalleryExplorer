#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'PSGalleryExplorer'
$PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------

InModuleScope 'PSGalleryExplorer' {
    BeforeAll {
        #github
        $objData1 = [PSCustomObject]@{
            Name                       = 'PoshGram'
            Version                    = [version]'1.10.1'
            Type                       = 'Module'
            Description                = 'PoshGram provides functionality to send various message types to a specified Telegram chat via the Telegram Bot API. Seperate PowerShell functions are used for each message type. Checks are included to ensure that file extensions, and file size restrictions are adhered to based on Telegram requirements.'
            Author                     = 'Jake Morrison'
            CompanyName                = 'jakewmorrison'
            Copyright                  = '(c) 2019 Jake Morrison. All rights reserved.'
            PublishedDate              = [datetime]'12/17/19 23:05:48'
            InstalledDate              = ''
            UpdatedDate                = ''
            LicenseUri                 = ''
            ProjectUri                 = 'https://github.com/techthoughts2/PoshGram'
            IconUri                    = 'https://github.com/techthoughts2/PoshGram/raw/master/media/PoshGram.png'
            Tags                       = @(
                'Animations',
                'Audio',
                'Automation',
                'bot',
                'Contact',
                'Contacts',
                'Coordinates',
                'Documents',
                'Gif',
                'Gifs',
                'Location',
                'Media',
                'Message',
                'Messaging',
                'Messenger',
                'Notification',
                'Notifications',
                'Notify',
                'Photo',
                'Photos',
                'Pictures',
                'Poll',
                'powershell',
                'powershell-module',
                'PSModule',
                'Send',
                'SM',
                'Sticker',
                'Stickers',
                'Sticker-Pack',
                'telegram',
                'telegram-bot-api',
                'telegramx',
                'Telegram-Sticker',
                'Telegram-Bot',
                'Venue',
                'Video',
                'Videos'
            )
            Includes                   = @{
                Function       = @(
                    'Get-TelegramStickerPackInfo',
                    'Send-TelegramContact',
                    'Send-TelegramLocalAnimation',
                    'Send-TelegramLocalAudio',
                    'Send-TelegramLocalDocument',
                    'Send-TelegramLocalPhoto',
                    'Send-TelegramLocalSticker',
                    'Send-TelegramLocalVideo',
                    'Send-TelegramLocation',
                    'Send-TelegramMediaGroup',
                    'Send-TelegramPoll',
                    'Send-TelegramSticker',
                    'Send-TelegramTextMessage',
                    'Send-TelegramURLAnimation',
                    'Send-TelegramURLAudio',
                    'Send-TelegramURLDocument',
                    'Send-TelegramURLPhoto',
                    'Send-TelegramURLSticker',
                    'Send-TelegramURLVideo',
                    'Send-TelegramVenue',
                    'Test-BotToken'
                )
                Workflow       = '{}'
                RoleCapability = '{}'
                Cmdlet         = '{}'
                DscResource    = '{}'
                Command        = @(
                    'Get-TelegramStickerPackInfo',
                    'Send-TelegramContact',
                    'Send-TelegramLocalAnimation',
                    'Send-TelegramLocalAudio',
                    'Send-TelegramLocalDocument',
                    'Send-TelegramLocalPhoto',
                    'Send-TelegramLocalSticker',
                    'Send-TelegramLocalVideo',
                    'Send-TelegramLocation',
                    'Send-TelegramMediaGroup',
                    'Send-TelegramPoll',
                    'Send-TelegramSticker',
                    'Send-TelegramTextMessage',
                    'Send-TelegramURLAnimation',
                    'Send-TelegramURLAudio',
                    'Send-TelegramURLDocument',
                    'Send-TelegramURLPhoto',
                    'Send-TelegramURLSticker',
                    'Send-TelegramURLVideo',
                    'Send-TelegramVenue',
                    'Test-BotToken'
                )
            }
            PowerShellGetFormatVersion = ''
            ReleaseNotes               = '@ 1.10.1:
            Fixed bug where DisableNotification had no effect when running Send-TelegramSticker
        1.10.0:
            Improved Help Formatting
            Added Send-TelegramURLSticker
            Added Send-TelegramLocalSticker
            Added Send-TelegramSticker
            Added Get-TelegramStickerPackInfo
            Added Send-TelegramPoll
            Added Send-TelegramVenue
            Added Send-TelegramContact
            DisableNotification and Streaming parameters changed from bool to switch on all functions
            Send-TelegramTextMessage: Preview parameter renamed to DisablePreview and changed from bool to switch
            Unit test and Infra test improvements
        1.0.2 :
            Addressed bug where certain UTF-8 characters would fail to send properly in Send-TelegramTextMessage
            Cosmetic code change for Invoke functions to use splat parameters
        1.0.0 :
            Addressed bug in Send-TelegramTextMessage that wasnt handling underscores
            Added code to support AWS Codebuild
        0.9.0 :
            Restructured module for CI/CD Workflow
            Added Invoke-Build capabilities to module
            Added Animation functionality:
                Send-TelegramLocalAnimation
                Send-TelegramURLAnimation
            Added location functionality:
                Send-TelegramLocation
            Added multi-media functionality:
                Send-TelegramMediaGroup
            Consolidated private support functions
            Code Logic improvements
        0.8.4 Added IconURI to manifest
        0.8.3 Initial beta release.
@'
            Dependencies               = '{}'
            RepositorySourceLocation   = 'https://www.powershellgallery.com/api/v2'
            Repository                 = 'PSGallery'
            PackageManagementProvider  = 'NuGet'
            AdditionalMetadata         = @{

                summary                   = 'PoshGram provides functionality to send various message types to a specified Telegram chat via the Telegram Bot API. Seperate PowerShell functions are used for each message type. Checks are included to ensure that file extensions, and file size restrictions are adhered to based on Telegram requirements.'
                ItemType                  = 'Module'
                CompanyName               = 'Tech Thoughts'
                updated                   = [datetime]'2020 - 01 - 05T19:10:07Z'
                isLatestVersion           = 'True'
                title                     = 'PoshGram'
                FileList                  = 'PoshGram.nuspec | PoshGram.psd1 | PoshGram.psm1 | asset\emoji.json | en-US\PoshGram-help.xml'
                IsPrerelease              = 'false'
                copyright                 = '(c) 2019 Jake Morrison. All rights reserved.'
                versionDownloadCount      = '1479'
                releaseNotes              = '@ 1.10.1:
        Fixed bug where DisableNotification had no effect when running Send-TelegramSticker
        1.10.0:
        Improved Help Formatting
        Added Send-TelegramURLSticker
        Added Send-TelegramLocalSticker
        Added Send-TelegramSticker
        Added Get-TelegramStickerPackInfo
        Added Send-TelegramPoll
        Added Send-TelegramVenue
        Added Send-TelegramContact
        DisableNotification and Streaming parameters changed from bool to switch on all functions
        Send-TelegramTextMessage: Preview parameter renamed to DisablePreview and changed from bool to switch
        Unit test and Infra test improvements
        1.0.2 :
        Addressed bug where certain UTF - 8 characters would fail to send properly in Send-TelegramTextMessage
        Cosmetic code change for Invoke functions to use splat parameters
        1.0.0 :
        Addressed bug in Send-TelegramTextMessage that wasnt handling underscores
        Added code to support AWS Codebuild
        0.9.0 :
        Restructured module for CI/CD Workflow
        Added Invoke-Build capabilities to module
        Added Animation functionality:
        Send-TelegramLocalAnimation
        Send-TelegramURLAnimation
        Added location functionality:
        Send-TelegramLocation
        Added multi-media functionality:
        Send-TelegramMediaGroup
        Consolidated private support functions
        Code Logic improvements
        0.8.4 Added IconURI to manifest
        0.8.3 Initial beta release.
@'
                lastUpdated               = '1/5/20 7:10:07 PM + 00:00'
                Authors                   = 'Jake Morrison'
                PackageManagementProvider = 'NuGet'
                tags                      = 'Animations Audio Automation bot Contact Contacts Coordinates Documents Gif Gifs Location Media Message Messaging Messenger Notification Notifications Notify Photo Photos Pictures Poll powershell powershell-module PSModule Send SM Sticker Stickers Sticker-Pack telegram telegram-bot-api telegramx Telegram-Sticker Telegram-Bot Venue Video Videos'
                PowerShellVersion         = [version]'6.1.0'
                developmentDependency     = 'False'
                NormalizedVersion         = '1.10.1'
                requireLicenseAcceptance  = 'False'
                GUID                      = '277b92bc-0ea9-4659-8f6c-ed5a1dfdfda2'
                created                   = '12/18/19 7:05:48 AM + 00:00'
                description               = 'PoshGram provides functionality to send various message types to a specified Telegram chat via the Telegram Bot API. Seperate PowerShell functions are used for each message type. Checks are included to ensure that file extensions, and file size restrictions are adhered to based on Telegram requirements.'
                published                 = '12/18/19 7:05:48 AM + 00:00'
                isAbsoluteLatestVersion   = 'True'
                downloadCount             = '2421'
                SourceName                = 'PSGallery'
                packageSize               = '87559'
                Functions                 = 'Get-TelegramStickerPackInfo Send-TelegramContact Send-TelegramLocalAnimation Send-TelegramLocalAudio Send-TelegramLocalDocument Send-TelegramLocalPhoto Send-TelegramLocalSticker Send-TelegramLocalVideo Send-TelegramLocation Send-TelegramMediaGroup Send-TelegramPoll Send-TelegramSticker Send-TelegramTextMessage Send-TelegramURLAnimation Send-TelegramURLAudio Send-TelegramURLDocument Send-TelegramURLPhoto Send-TelegramURLSticker Send-TelegramURLVideo Send-TelegramVenue Test-BotToken'
            }
            GitHubInfo                 = @{
                Subscribers = '5'
                GitStatus   = 'True'
                Forks       = '4'
                Watchers    = '28'
                Issues      = '13'
                StarCount   = '28'
                License     = 'MIT License'
                Created     = [datetime]'06/28/18 01:42:08'
                Updated     = [datetime]'01/01/20 06:27:11'
            }
        } #objData1
        #github
        $objData2 = [PSCustomObject]@{

            Name                       = 'Catesta'
            Version                    = [version]'0.8.5'
            Type                       = 'Module'
            Description                = 'Catesta is a PowerShell module project generator. It uses templates to rapidly scaffold test and build integration for a variety of CI/CD platforms.'
            Author                     = 'Jake Morrison'
            CompanyName                = 'jakewmorrison'
            Copyright                  = '(c) Jake Morrison. All rights reserved.'
            PublishedDate              = [datetime]'12/21/19 23:01:38'
            InstalledDate              = ''
            UpdatedDate                = ''
            LicenseUri                 = ''
            ProjectUri                 = 'https://github.com/techthoughts2/Catesta'
            IconUri                    = 'https://github.com/techthoughts2/Catesta/raw/master/media/CatestaIcon.png'
            Tags                       = @(
                'Module'
                'Modules'
                'Plaster'
                'Template'
                'Project'
                'Scaffold'
                'Cross-Platform'
                'CrossPlatform'
                'MultiCloud'
                'PowerShell'
                'pwsh'
                'CICD'
                'Windows'
                'Linux'
                'MacOS'
                'Azure'
                'Azure-DevOps'
                'AWS'
                'CodeBuild'
                'AWS-CodeBuild'
                'AppVeyor'
                'GitHub'
                'Actions'
                'GitHub-Actions'
                'PSModule'
            )
            Includes                   = @{
                Cmdlet         = '{}'
                Workflow       = '{}'
                DscResource    = '{}'
                RoleCapability = '{}'
                Command        = @(
                    'New-PowerShellProject'
                )
                Function       = @(
                    'New-PowerShellProject'
                )
            }
            PowerShellGetFormatVersion = ''
            ReleaseNotes               = 'https://github.com/techthoughts2/Catesta/blob/master/.github/CHANGELOG.md'
            Dependencies               = '{}'
            RepositorySourceLocation   = 'https://www.powershellgallery.com/api/v2/'
            Repository                 = 'PSGallery'
            PackageManagementProvider  = 'NuGet'
            AdditionalMetadata         = @{
                summary                   = 'Catesta is a PowerShell module project generator. It uses templates to rapidly scaffold test and build integration for a variety of CI/CD platforms.'
                versionDownloadCount      = '13'
                NormalizedVersion         = [version]'0.8.5'
                FileList                  = 'Catesta.nuspec|Catesta.psd1|Catesta.psm1|en-US\Catesta-help.xml|Resources\AppVeyor\actions_bootstrap.ps1|Resources\AppVeyor\appveyor.yml|Resources\AppVeyor\plasterManifest.xml|Resources\AWS\buildspec_powershell_windows.yml|Resources\AWS\buildspec_pwsh_linux.yml|Resources\AWS\buildspec_pwsh_windows.yml|Resources\AWS\configure_aws_credential.ps1|Resources\AWS\install_modules.ps1|Resources\AWS\plasterManifest.xml|Resources\Azure\actions_bootstrap.ps1|Resources\Azure\azure-pipelines.yml|Resources\Azure\plasterManifest.xml|Resources\GitHubActions\actions_bootstrap.ps1|Resources\GitHubActions\plasterManifest.xml|Resources\GitHubFiles\.gitignore|Resources\GitHubFiles\APACHELICENSE|Resources\GitHubFiles\CHANGELOG.md|Resources\GitHubFiles\CODE_OF_CONDUCT.md|Resources\GitHubFiles\CONTRIBUTING.md|Resources\GitHubFiles\GNULICENSE|Resources\GitHubFiles\ISCLICENSE|Resources\GitHubFiles\MITLICENSE|Resources\GitHubFiles\PULL_REQUEST_TEMPLATE.md|Resources\Vanilla\plasterManifest.xml|Resources\AWS\CloudFormation\PowerShellCodeBuildCC.yml|Resources\AWS\CloudFormation\PowerShellCodeBuildGit.yml|Resources\AWS\CloudFormation\S3BucketsForPowerShellDevelopment.yml|Resources\Editor\VSCode\extensions.json|Resources\Editor\VSCode\settings.json|Resources\Editor\VSCode\tasks.json|Resources\GitHubActions\workflows\wf_Linux.yml|Resources\GitHubActions\workflows\wf_MacOS.yml|Resources\GitHubActions\workflows\wf_Windows.yml|Resources\GitHubActions\workflows\wf_Windows_Core.yml|Resources\GitHubFiles\ISSUE_TEMPLATE\bug-report.md|Resources\GitHubFiles\ISSUE_TEMPLATE\feature_request.md|Resources\Module\src\PSModule.build.ps1|Resources\Module\src\PSModule.Settings.ps1|Resources\Module\src\PSScriptAnalyzerSettings.psd1|Resources\Module\src\Module\Imports.ps1|Resources\Module\src\Module\Module.psm1|Resources\Module\src\Module\Private\Get-PrivateHelloWorld.ps1|Resources\Module\src\Module\Public\Get-HelloWorld.ps1|Resources\Module\src\Tests\InfraStructure\SampleInfraTest.Tests.ps1|Resources\Module\src\Tests\Unit\ExportedFunctions.Tests.ps1|Resources\Module\src\Tests\Unit\Module-Function.Tests.ps1|Resources\Module\src\Tests\Unit\PSModule-Module.Tests.ps1'
                isAbsoluteLatestVersion   = 'True'
                created                   = '12/21/19 23:01:38 -08:00'
                downloadCount             = '65'
                copyright                 = '(c) Jake Morrison. All rights reserved.'
                updated                   = [datetime]'2020-01-09T06:06:14Z'
                tags                      = 'Module Modules Plaster Template Project Scaffold Cross-Platform CrossPlatform MultiCloud PowerShell pwsh CICD Windows Linux MacOS Azure Azure-DevOps AWS CodeBuild AWS-CodeBuild AppVeyor GitHub Actions GitHub-Actions PSModule'
                requireLicenseAcceptance  = 'False'
                releaseNotes              = 'https://github.com/techthoughts2/Catesta/blob/master/.github/CHANGELOG.md'
                Functions                 = 'New-PowerShellProject'
                ItemType                  = 'Module'
                isLatestVersion           = 'True'
                Authors                   = 'Jake Morrison'
                CompanyName               = 'TechThoughts'
                PackageManagementProvider = 'NuGet'
                lastUpdated               = '01/09/20 06:06:14 -08:00'
                PowerShellVersion         = '5.1'
                developmentDependency     = 'False'
                IsPrerelease              = 'false'
                packageSize               = '75632'
                SourceName                = 'PSGallery'
                published                 = '12/21/19 23:01:38 -08:00'
                description               = 'Catesta is a PowerShell module project generator. It uses templates to rapidly scaffold test and build integration for a variety of CI/CD platforms.'
                GUID                      = '6796b193-9013-468a-b022-837749af2d06'
            }
            GitHubInfo                 = @{
                StarCount   = '39'
                Created     = [datetime]'12/02/19 19:00:22'
                License     = 'MIT License'
                Updated     = [datetime]'12/26/19 01:36:56'
                Issues      = '3'
                Watchers    = '39'
                GitStatus   = 'True'
                Forks       = '1'
                Subscribers = '1'
            }
        } #objData2
        #nogithub - popular
        $objData3 = [PSCustomObject]@{
            Name                       = 'PSLogging'
            Version                    = [version]'2.5.2'
            Type                       = 'Module'
            Description                = 'Creates and manages log files for your scripts.'
            Author                     = 'LucaSturlese'
            CompanyName                = '9to5IT'
            Copyright                  = '(c) 2015 Luca Sturlese. All rights reserved.'
            PublishedDate              = [datetime]'11/22/15 10:26:55'
            InstalledDate              = ''
            UpdatedDate                = ''
            LicenseUri                 = 'http://9to5it.com/powershell-logging-v2-easily-create-log-files'
            ProjectUri                 = 'http://9to5it.com/powershell-logging-v2-easily-create-log-files'
            IconUri                    = ''
            Tags                       = @(
                'Logging'
                'LogFiles'
                'PSModule'
            )
            Includes                   = @{
                Cmdlet         = '{}'
                Workflow       = '{}'
                DscResource    = '{}'
                RoleCapability = '{}'
                Command        = @(
                    'Start-Log'
                    'Write-LogInfo'
                    'Write-LogWarning'
                    'Write-LogError'
                    'Stop-Log'
                    'Send-Log'
                )
                Function       = @(
                    'Start-Log'
                    'Write-LogInfo'
                    'Write-LogWarning'
                    'Write-LogError'
                    'Stop-Log'
                    'Send-Log'
                )
            }
            PowerShellGetFormatVersion = ''
            ReleaseNotes               = 'Removed HelpInfoURI from Module Manifest file as was causing an issue with PowerShell 2.0'
            Dependencies               = '{}'
            RepositorySourceLocation   = 'https://www.powershellgallery.com/api/v2/'
            Repository                 = 'PSGallery'
            PackageManagementProvider  = 'NuGet'
            AdditionalMetadata         = @{
                summary                   = 'Creates and manages log files for your scripts.'
                versionDownloadCount      = '12347798'
                NormalizedVersion         = '2.5.2'
                FileList                  = 'PSLogging.nuspec|PSLogging.psd1|PSLogging.psm1'
                isAbsoluteLatestVersion   = 'True'
                created                   = '11/22/15 10:26:55 -08:00'
                downloadCount             = '12348073'
                copyright                 = '(c) 2015 Luca Sturlese. All rights reserved.'
                updated                   = [datetime]'2020-01-10T06:11:51Z'
                tags                      = 'Logging LogFiles PSModule PSFunction_Start-Log PSCommand_Start-Log PSFunction_Write-LogInfo PSCommand_Write-LogInfo PSFunction_Write-LogWarning PSCommand_Write-LogWarning PSFunction_Write-LogError PSCommand_Write-LogError PSFunction_Stop-Log PSCommand_Stop-Log PSFunction_Send-Log PSCommand_Send-Log PSIncludes_Function'
                requireLicenseAcceptance  = 'True'
                releaseNotes              = 'Removed HelpInfoURI from Module Manifest file as was causing an issue with PowerShell 2.0'
                ItemType                  = 'Module'
                isLatestVersion           = 'True'
                Authors                   = 'LucaSturlese'
                CompanyName               = 'http://9to5IT.com'
                PackageManagementProvider = 'NuGet'
                lastUpdated               = '01/10/20 06:11:51 -08:00'
                developmentDependency     = 'False'
                IsPrerelease              = 'false'
                packageSize               = '8262'
                SourceName                = 'PSGallery'
                published                 = '11/22/15 10:26:55 -08:00'
                description               = 'Creates and manages log files for your scripts.'
                GUID                      = '7dba4b34-6bf3-459c-adba-4de5ff497f07'
            }



        } #objData3
        #github - corp
        $objData4 = [PSCustomObject]@{
            Name                       = 'AWS.Tools.Common'
            Version                    = [version]'4.0.2.0'
            Type                       = 'Module'
            Description                = @'
        The AWS Tools for PowerShell lets developers and administrators manage their AWS services from the PowerShell scripting environment. In order to manage each AWS service, install the corresponding module (e.g. AWS.Tools.EC2, AWS.Tools.S3...).
        The module AWS.Tools.Installer (https://www.powershellgallery.com/packages/AWS.Tools.Installer/) makes it easier to install, update and uninstall the AWS.Tools modules.
        This version of AWS Tools for PowerShell is compatible with Windows PowerShell 5.1+ and PowerShell Core 6+ on Windows, Linux and macOS. When running on Windows PowerShell, .NET Framework 4.7.2 or newer is required.
        Alternative modules, AWSPowerShell.NetCore and AWSPowerShell, provide support for all AWS services from a single module and also support older versions of Windows PowerShell and .NET Framework.
'@
            Author                     = 'Amazon.com Inc'
            CompanyName                = 'aws-dotnet-sdk-team'
            Copyright                  = 'Copyright 2012-2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.'
            PublishedDate              = [datetime]'12/13/19 16:44:41'
            InstalledDate              = ''
            UpdatedDate                = ''
            LicenseUri                 = 'https://aws.amazon.com/apache-2-0/'
            ProjectUri                 = 'https://github.com/aws/aws-tools-for-powershell'
            IconUri                    = 'https://sdk-for-net.amazonwebservices.com/images/AWSLogo128x128.png'
            Tags                       = @(
                'AWS'
                'cloud'
                'Windows'
                'PSEdition_Desktop'
                'PSEdition_Core'
                'Linux'
                'MacOS'
                'Mac'
                'PSModule'
            )
            Includes                   = @{
                Cmdlet         = @(
                    'Clear-AWSHistory'
                    'Set-AWSHistoryConfiguration'
                    'Initialize-AWSDefaultConfiguration'
                    'Clear-AWSDefaultConfiguration'
                    'Get-AWSPowerShellVersion'
                    'New-AWSCredential'
                    'Set-AWSCredential'
                    'Clear-AWSCredential'
                    'Get-AWSCredential'
                    'Set-AWSSamlEndpoint'
                    'Set-AWSSamlRoleProfile'
                    'Get-AWSService'
                    'Get-AWSCmdletName'
                    'Add-AWSLoggingListener'
                    'Remove-AWSLoggingListener'
                    'Set-AWSResponseLogging'
                    'Enable-AWSMetricsLogging'
                    'Disable-AWSMetricsLogging'
                    'Set-AWSProxy'
                    'Clear-AWSProxy'
                    'Get-AWSPublicIpAddressRange'
                    'Set-DefaultAWSRegion'
                    'Clear-DefaultAWSRegion'
                    'Get-DefaultAWSRegion'
                    'Get-AWSRegion'
                    'Remove-AWSCredentialProfile'
                )
                DscResource    = '{}'
                RoleCapability = '{}'
                Command        = @(
                    'Clear-AWSHistory'
                    'Set-AWSHistoryConfiguration'
                    'Initialize-AWSDefaultConfiguration'
                    'Clear-AWSDefaultConfiguration'
                    'Get-AWSPowerShellVersion'
                    'New-AWSCredential'
                    'Set-AWSCredential'
                    'Clear-AWSCredential'
                    'Get-AWSCredential'
                    'Set-AWSSamlEndpoint'
                    'Set-AWSSamlRoleProfile'
                    'Get-AWSService'
                    'Get-AWSCmdletName'
                    'Add-AWSLoggingListener'
                    'Remove-AWSLoggingListener'
                    'Set-AWSResponseLogging'
                    'Enable-AWSMetricsLogging'
                    'Disable-AWSMetricsLogging'
                    'Set-AWSProxy'
                    'Clear-AWSProxy'
                    'Get-AWSPublicIpAddressRange'
                    'Set-DefaultAWSRegion'
                    'Clear-DefaultAWSRegion'
                    'Get-DefaultAWSRegion'
                    'Get-AWSRegion'
                    'Remove-AWSCredentialProfile'
                )
            }
            PowerShellGetFormatVersion = ''
            ReleaseNotes               = 'https://github.com/aws/aws-tools-for-powershell/blob/master/CHANGELOG.md'
            Dependencies               = '{}'
            RepositorySourceLocation   = 'https://www.powershellgallery.com/api/v2/'
            Repository                 = 'PSGallery'
            PackageManagementProvider  = 'NuGet'
            AdditionalMetadata         = @{
                summary                   = '@
            The AWS Tools for PowerShell lets developers and administrators manage their AWS services from the PowerShell scripting environment. In order to manage each AWS service, install the corresponding module (e.g. AWS.Tools.EC2, AWS.Tools.S3...).
            The module AWS.Tools.Installer (https://www.powershellgallery.com/packages/AWS.Tools.Installer/) makes it easier to install, update and uninstall the AWS.Tools modules.
            This version of AWS Tools for PowerShell is compatible with Windows PowerShell 5.1+ and PowerShell Core 6+ on Windows, Linux and macOS. When running on Windows PowerShell, .NET Framework 4.7.2 or newer is required.
            Alternative modules, AWSPowerShell.NetCore and AWSPowerShell, provide support for all AWS services from a single module and also support older versions of Windows PowerShell and .NET Framework.
@'
                packageSize               = '484726'
                isAbsoluteLatestVersion   = 'True'
                PackageManagementProvider = 'NuGet'
                tags                      = 'AWS cloud Windows PSEdition_Desktop PSEdition_Core Linux MacOS Mac PSModule'
                Authors                   = 'Amazon.com Inc'
                DotNetFrameworkVersion    = '4.7.2'
                updated                   = [datetime]'2020-01-10T06:21:53Z'
                downloadCount             = '103889'
                created                   = '12/13/19 16:44:41 -08:00'
                FileList                  = 'AWS.Tools.Common.nuspec|AWS.Tools.Common.Aliases.psm1|AWS.Tools.Common.Completers.psm1|AWS.Tools.Common.dll|AWS.Tools.Common.dll-Help.xml|AWS.Tools.Common.Format.ps1xml|AWS.Tools.Common.psd1|AWS.Tools.Common.XML|AWSSDK.Core.dll|AWSSDK.SecurityToken.dll|ImportGuard.ps1'
                IsPrerelease              = 'false'
                GUID                      = 'e5b05bf3-9eee-47b2-81f2-41ddc0501b86'
                NormalizedVersion         = '4.0.2'
                versionDownloadCount      = '14233'
                published                 = '12/13/19 16:44:41 -08:00'
                releaseNotes              = 'https://github.com/aws/aws-tools-for-powershell/blob/master/CHANGELOG.md'
                CompanyName               = 'Amazon.com, Inc'
                PowerShellVersion         = '5.1'
                requireLicenseAcceptance  = 'False'
                description               = '@
            The AWS Tools for PowerShell lets developers and administrators manage their AWS services from the PowerShell scripting environment. In order to manage each AWS service, install the corresponding module (e.g. AWS.Tools.EC2, AWS.Tools.S3...).
            The module AWS.Tools.Installer (https://www.powershellgallery.com/packages/AWS.Tools.Installer/) makes it easier to install, update and uninstall the AWS.Tools modules.
            This version of AWS Tools for PowerShell is compatible with Windows PowerShell 5.1+ and PowerShell Core 6+ on Windows, Linux and macOS. When running on Windows PowerShell, .NET Framework 4.7.2 or newer is required.
            Alternative modules, AWSPowerShell.NetCore and AWSPowerShell, provide support for all AWS services from a single module and also support older versions of Windows PowerShell and .NET Framework.
@'
                isLatestVersion           = 'True'
                Cmdlets                   = 'Clear-AWSHistory Set-AWSHistoryConfiguration Initialize-AWSDefaultConfiguration Clear-AWSDefaultConfiguration Get-AWSPowerShellVersion New-AWSCredential Set-AWSCredential Clear-AWSCredential Get-AWSCredential Set-AWSSamlEndpoint Set-AWSSamlRoleProfile Get-AWSService Get-AWSCmdletName Add-AWSLoggingListener Remove-AWSLoggingListener Set-AWSResponseLogging Enable-AWSMetricsLogging Disable-AWSMetricsLogging Set-AWSProxy Clear-AWSProxy Get-AWSPublicIpAddressRange Set-DefaultAWSRegion Clear-DefaultAWSRegion Get-DefaultAWSRegion Get-AWSRegion Remove-AWSCredentialProfile'
                ItemType                  = 'Module'
                SourceName                = 'PSGallery'
                copyright                 = 'Copyright 2012-2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.'
                developmentDependency     = 'False'
                lastUpdated               = '01/10/20 06:21:53 -08:00'
            }
            GitHubInfo                 = @{
                StarCount   = '75'
                Created     = [datetime]'03/26/19 17:41:43'
                License     = 'Apache License 2.0'
                Updated     = [datetime]'01/03/20 16:01:24'
                Watchers    = '75'
                Issues      = '3'
                GitStatus   = 'True'
                Forks       = '21'
                Subscribers = '16'
            }
        } #objData4
        $dataSet = @()
        $dataSet += $objData1
        $dataSet += $objData2
        $dataSet += $objData3
        $dataSet += $objData4

        $WarningPreference = 'SilentlyContinue'
        $ErrorActionPreference = 'SilentlyContinue'
    } #beforeAll
    Describe 'Find-PSGModule' -Tag Unit {
        BeforeEach {
            $script:glData = $dataSet
            Mock -CommandName Import-XMLDataSet -MockWith {
                $true
            }
        } #before_each
        Context 'ByDownloads' {
            Context 'Requirements' {
                It 'Should not process if no parameters are specified' {
                    Mock -CommandName Find-PSGModule -MockWith { } #endMock
                    { Find-PSGModule }
                    Assert-MockCalled Find-PSGModule -Scope It -Exactly -Times 0
                } #it
            } #context_Requirements
            Context 'Error' {
                It 'should return null if the dataset can not be loaded' {
                    Mock -CommandName Import-XMLDataSet -MockWith {
                        $false
                    }
                    Find-PSGModule -ByDownloads | Should -BeNullOrEmpty
                } #it
            } #context_Error
            Context 'Success' {
                It 'should return expected results when finding default downloads' {
                    $eval = Find-PSGModule -ByDownloads
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 2
                    $eval[0].Name | Should -BeExactly 'PoshGram'
                } #it
                It 'should return expected results when finding downloads with corp included' {
                    $eval = Find-PSGModule -ByDownloads -IncludeCorps
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 3
                    $eval[0].Name | Should -BeExactly 'AWS.Tools.Common'
                } #it
                It 'should return expected results when finding downloads with popular included' {
                    $eval = Find-PSGModule -ByDownloads -IncludeRegulars
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 3
                    $eval[0].Name | Should -BeExactly 'PSLogging'
                } #it
                It 'should return expected results when finding downloads with everything included' {
                    $eval = Find-PSGModule -ByDownloads -IncludeRegulars -IncludeCorps
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 4
                    $eval[0].Name | Should -BeExactly 'PSLogging'
                } #it
            } #context_Success
        } #context_ByDownloads
        Context 'ByRepoInfo' {
            Context 'Success' {
                It 'should return expected results when finding default Repository StarCount' {
                    $eval = Find-PSGModule -ByRepoInfo StarCount
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 2
                    $eval[0].Name | Should -BeExactly 'Catesta'
                } #it
                It 'should return expected results when finding Repository StarCount with corp included' {
                    $eval = Find-PSGModule -ByRepoInfo StarCount -IncludeCorps
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 3
                    $eval[0].Name | Should -BeExactly 'AWS.Tools.Common'
                } #it
                It 'should return expected results when finding Repository StarCount with popular included' {
                    $eval = Find-PSGModule -ByRepoInfo StarCount -IncludeRegulars
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 2
                    $eval[0].Name | Should -BeExactly 'Catesta'
                } #it
                It 'should return expected results when finding Repository StarCount with everything included' {
                    $eval = Find-PSGModule -ByRepoInfo StarCount -IncludeRegulars -IncludeCorps
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 3
                    $eval[0].Name | Should -BeExactly 'AWS.Tools.Common'
                } #it
                It 'should return expected results when finding default Repository Subscribers' {
                    $eval = Find-PSGModule -ByRepoInfo Subscribers
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 2
                    $eval[0].Name | Should -BeExactly 'PoshGram'
                } #it
                It 'should return expected results when finding default Repository Issues' {
                    $eval = Find-PSGModule -ByRepoInfo Issues
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 2
                    $eval[0].Name | Should -BeExactly 'PoshGram'
                } #it
                It 'should return expected results when finding default Repository Forks' {
                    $eval = Find-PSGModule -ByRepoInfo Forks
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 2
                    $eval[0].Name | Should -BeExactly 'PoshGram'
                } #it
            } #context_Success
        } #context_ByRepoInfo
        Context 'ByRecentUpdate' {
            Context 'Success' {
                It 'should return expected results when finding recent default gallery updates' {
                    $eval = Find-PSGModule -ByRecentUpdate GalleryUpdate
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 2
                    $eval[0].Name | Should -BeExactly 'Catesta'
                } #it
                It 'should return expected results when finding recent gallery updates with corp included' {
                    $eval = Find-PSGModule -ByRecentUpdate GalleryUpdate -IncludeCorps
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 3
                    $eval[0].Name | Should -BeExactly 'AWS.Tools.Common'
                } #it
                It 'should return expected results when finding recent gallery updates with popular included' {
                    $eval = Find-PSGModule -ByRecentUpdate GalleryUpdate -IncludeRegulars
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 3
                    $eval[0].Name | Should -BeExactly 'PSLogging'
                } #it
                It 'should return expected results when finding recent gallery updates with everything included' {
                    $eval = Find-PSGModule -ByRecentUpdate GalleryUpdate -IncludeRegulars -IncludeCorps
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 4
                    $eval[0].Name | Should -BeExactly 'AWS.Tools.Common'
                } #it
                It 'should return expected results when finding Repository default updates' {
                    $eval = Find-PSGModule -ByRecentUpdate RepoUpdate
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 2
                    $eval[0].Name | Should -BeExactly 'PoshGram'
                } #it
            } #context_Success
        } #context_ByRecentUpdate
        Context 'ByRandom' {
            Context 'Success' {
                It 'should return expected results when finding default random' {
                    $eval = Find-PSGModule -ByRandom
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 2
                    $eval[0].Name | Should -BeExactly 'PoshGram'
                } #it
                It 'should return expected results when finding random with corp included' {
                    $eval = Find-PSGModule -ByRandom -IncludeCorps
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 3
                    $eval[0].Name | Should -BeExactly 'AWS.Tools.Common'
                } #it
                It 'should return expected results when finding random with popular included' {
                    $eval = Find-PSGModule -ByRandom -IncludeRegulars
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 3
                    $eval[0].Name | Should -BeExactly 'PSLogging'
                } #it
                It 'should return expected results when finding random with everything included' {
                    $eval = Find-PSGModule -ByRandom -IncludeRegulars -IncludeCorps
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 4
                    $eval[0].Name | Should -BeExactly 'PSLogging'
                } #it
            } #context_Success
        } #context_ByRandom
        Context 'ByName' {
            Context 'Requirements' {
                It 'Should not process if a valid module name is not provided' {
                    Mock -CommandName Find-PSGModule -MockWith { } #endMock
                    { Find-PSGModule -ByName 'Posh*Gram' }
                    Assert-MockCalled Find-PSGModule -Scope It -Exactly -Times 0
                } #it
            } #context_Requirements
            Context 'Success' {
                It 'should return null when the module name is not found' {
                    Find-PSGModule -ByName ModuleNoExist | Should -BeNullOrEmpty
                } #it
                It 'should return expected results when finding module name on default' {
                    $eval = Find-PSGModule -ByName 'PoshGram'
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 1
                    $eval.Name | Should -BeExactly 'PoshGram'
                } #it
                It 'should return expected results when finding module name on default' {
                    $eval = Find-PSGModule -ByName 'AWS.Tools.Common' -IncludeCorps
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 1
                    $eval.Name | Should -BeExactly 'AWS.Tools.Common'
                } #it
                It 'should return expected results when finding module name with corp included' {
                    $eval = Find-PSGModule -ByName 'AWS.Tools.Common' -IncludeCorps
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 1
                    $eval.Name | Should -BeExactly 'AWS.Tools.Common'
                } #it
                It 'should return expected results when finding module name with popular included' {
                    $eval = Find-PSGModule -ByName 'PSLogging' -IncludeRegulars
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 1
                    $eval.Name | Should -BeExactly 'PSLogging'
                } #it
                It 'should return expected results when finding module name with everything included' {
                    $eval = Find-PSGModule -ByName 'AWS.Tools.Common' -IncludeRegulars -IncludeCorps
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 1
                    $eval.Name | Should -BeExactly 'AWS.Tools.Common'
                } #it
                It 'should return expteced results when finding module name with wild card' {
                    $eval = Find-PSGModule -ByName 'P*' -IncludeRegulars -IncludeCorps
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 2
                    $eval[0].Name | Should -BeExactly 'PoshGram'
                } #it
            } #context_Success
        } #context_ByName
        Context 'ByTag' {
            Context 'Requirements' {
                It 'Should not process if a valid module tag is not provided' {
                    Mock -CommandName Find-PSGModule -MockWith { } #endMock
                    { Find-PSGModule -ByTag 'Tele-Gram' }
                    Assert-MockCalled Find-PSGModule -Scope It -Exactly -Times 0
                } #it
            } #context_Requirements
            Context 'Success' {
                It 'should return null when the module is not found' {
                    Find-PSGModule -ByTag ModuleNoExist | Should -BeNullOrEmpty
                } #it
                It 'should return expected results when finding module tag on default' {
                    $eval = Find-PSGModule -ByTag 'telegram'
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 1
                    $eval.Name | Should -BeExactly 'PoshGram'
                } #it
                It 'should return expected results when finding module tag with corp included' {
                    $eval = Find-PSGModule -ByTag 'AWS' -IncludeCorps
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 2
                    $eval[0].Name | Should -BeExactly 'AWS.Tools.Common'
                } #it
                It 'should return expected results when finding module tag with popular included' {
                    $eval = Find-PSGModule -ByTag 'Logging' -IncludeRegulars
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 1
                    $eval.Name | Should -BeExactly 'PSLogging'
                } #it
                It 'should return expected results when finding module tag with everything included' {
                    $eval = Find-PSGModule -ByTag 'PowerShell' -IncludeRegulars -IncludeCorps
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 2
                    $eval[0].Name | Should -BeExactly 'PoshGram'
                } #it
            } #context_Success
        } #context_ByTag
        Context 'Everything' {
            Context 'Success' {
                It 'should return expected results when no options are specified' {
                    $eval = Find-PSGModule
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 2
                    $eval[0].Name | Should -BeExactly 'PoshGram'
                } #it
                It 'should return expected results when no options are specified with everything included' {
                    $eval = Find-PSGModule -IncludeCorps -IncludeRegulars
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeExactly 4
                    $eval[0].Name | Should -BeExactly 'PSLogging'
                } #it
            } #context_Success
        } #context_everything
    } #describe_Find-PSGModule
} #inModule
