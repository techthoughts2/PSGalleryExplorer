BeforeDiscovery {
    Set-Location -Path $PSScriptRoot
    $ModuleName = 'PSGalleryExplorer'
    $PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
    #if the module is already in memory, remove it
    Get-Module $ModuleName -ErrorAction SilentlyContinue | Remove-Module -Force
    Import-Module $PathToManifest -Force
}

InModuleScope 'PSGalleryExplorer' {

    BeforeAll {
        #github
        $objData1 = [PSCustomObject]@{
            Name                       = 'PoshGram'
            Version                    = [version]'2.3.0'
            Type                       = 'Module'
            Description                = 'PoshGram provides functionality to send various message types to a specified Telegram chat via the Telegram Bot API. Separate PowerShell functions are used for each message type. Checks are included to ensure that file extensions, and file size restrictions are adhered to based on Telegram requirements.'
            Author                     = 'Jake Morrison'
            CompanyName                = 'jakewmorrison'
            Copyright                  = '(c) 2019 Jake Morrison. All rights reserved.'
            PublishedDate              = [datetime]'11/26/22 22:07:00'
            InstalledDate              = ''
            UpdatedDate                = ''
            LicenseUri                 = ''
            ProjectUri                 = 'https://github.com/techthoughts2/PoshGram'
            IconUri                    = 'https://github.com/techthoughts2/PoshGram/raw/main/media/PoshGram.png'
            Tags                       = @(
                'Animations',
                'Audio',
                'Automation',
                'bot',
                'Contact',
                'Contacts',
                'Coordinates',
                'Dice',
                'Document',
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
                'Texting',
                'Venue',
                'Video',
                'Videos'
            )
            Includes                   = @{
                Function       = @(
                    'Get-TelegramStickerPackInfo',
                    'Send-TelegramContact',
                    'Send-TelegramDice',
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
                    'Send-TelegramDice',
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
            ReleaseNotes               = 'https://github.com/techthoughts2/PoshGram/blob/main/.github/CHANGELOG.md'
            Dependencies               = '{}'
            RepositorySourceLocation   = 'https://www.powershellgallery.com/api/v2'
            Repository                 = 'PSGallery'
            PackageManagementProvider  = 'NuGet'
            AdditionalMetadata         = @{
                summary                   = 'PoshGram provides functionality to send various message types to a specified Telegram chat via the Telegram Bot API. Separate PowerShell functions are used for each message type. Checks are included to ensure that file extensions, and file size restrictions are adhered to based on Telegram requirements.'
                requireLicenseAcceptance  = 'False'
                SourceName                = 'PSGallery'
                versionDownloadCount      = '1101'
                copyright                 = '(c) Jake Morrison. All rights reserved.'
                published                 = [datetime]'11/27/2022 4:07:00 AM +00:00'
                PowerShellVersion         = '6.1.0'
                FileList                  = 'PoshGram.nuspec|PoshGram.psd1|PoshGram.psm1|asset\emoji.json|en-US\PoshGram-help.xml'
                tags                      = 'Animations Audio Automation bot Contact Contacts Coordinates Dice Document Documents Gif Gifs Location Media Message Messaging Messenger Notification Notifications Notify Photo Photos Pictures Poll powershell powershell-module PSModule Send SM Sticker Stickers Sticker-Pack telegram telegram-bot-api telegramx Telegram-Sticker Telegram-Bot Texting Venue Video Videos'
                lastUpdated               = '4/6/2023 6:59:18 AM +01:00'
                ItemType                  = 'Module'
                packageSize               = '94909'
                title                     = 'PoshGram'
                PackageManagementProvider = 'NuGet'
                created                   = [datetime]'11/27/2022 4:07:00 AM +00:00'
                description               = 'PoshGram provides functionality to send various message types to a specified Telegram chat via the Telegram Bot API. Separate PowerShell functions are used for each message type. Checks are included to ensure that file extensions, and file size restrictions are adhered to based on Telegram requirements.'
                isAbsoluteLatestVersion   = 'True'
                developmentDependency     = 'False'
                CompanyName               = 'TechThoughts'
                NormalizedVersion         = '2.3.0'
                IsPrerelease              = 'false'
                Functions                 = @(
                    'Get-TelegramStickerPackInfo',
                    'Send-TelegramContact',
                    'Send-TelegramDice',
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
                releaseNotes              = 'https://github.com/techthoughts2/PoshGram/blob/main/.github/CHANGELOG.md'
                downloadCount             = '81891'
                updated                   = [datetime]'2023-04-06T06:59:18Z'
                isLatestVersion           = 'True'
                Authors                   = 'Jake Morrison'
                GUID                      = '277b92bc-0ea9-4659-8f6c-ed5a1dfdfda2'
            }
            ModuleSize                 = '1022897'
            ModuleFileCount            = '4'
            ProjectInfo                = @{
                GitStatus   = 'True'
                StarCount   = '115'
                Subscribers = '10'
                Watchers    = '115'
                Created     = [datetime]'06/28/18 01:42:08'
                Updated     = [datetime]'03/25/23 15:02:51'
                Forks       = '13'
                License     = 'MIT License'
                Issues      = '4'
            }
        } #objData1
        #github
        $objData2 = [PSCustomObject]@{
            Name                       = 'Catesta'
            Version                    = [version]'2.0.0'
            Type                       = 'Module'
            Description                = 'Catesta is a PowerShell module project generator. It uses templates to rapidly scaffold test and build integration for a variety of CI/CD platforms.'
            Author                     = 'Jake Morrison'
            CompanyName                = 'jakewmorrison'
            Copyright                  = '(c) Jake Morrison. All rights reserved.'
            PublishedDate              = [datetime]'02/18/23 17:09:54'
            InstalledDate              = ''
            UpdatedDate                = ''
            LicenseUri                 = ''
            ProjectUri                 = 'https://github.com/techthoughts2/Catesta'
            IconUri                    = 'https://github.com/techthoughts2/Catesta/raw/main/media/CatestaIcon.png'
            Tags                       = @(
                'Actions',
                'AppVeyor',
                'AWS',
                'AWS-CodeBuild',
                'Azure',
                'AzureDevOps',
                'Azure-DevOps',
                'AzureRepos',
                'Bitbucket',
                'BitbucketPipelines',
                'CI',
                'CICD',
                'CICDPipeline',
                'CodeBuild',
                'CodeCommit',
                'Cross-Platform',
                'CrossPlatform',
                'CrossPlatformDevelopment',
                'GitHub',
                'GitHub-Actions',
                'GitHubWorkflow',
                'GitLab',
                'GitLabPipeline',
                'GitLab-Runner',
                'Extension',
                'Linux',
                'MacOS',
                'Module',
                'Modules',
                'MultiCloud',
                'Plaster',
                'PowerShell',
                'PowerShellModule',
                'Project',
                'pwsh',
                'ReadtheDocs',
                'Scaffold',
                'Secret',
                'SecretVault',
                'Secrets',
                'Template',
                'Vault',
                'Windows',
                'PSModule'
            )
            Includes                   = @{
                Cmdlet         = '{}'
                Workflow       = '{}'
                DscResource    = '{}'
                RoleCapability = '{}'
                Command        = @(
                    'New-ModuleProject',
                    'New-VaultProject'
                )
                Function       = @(
                    'New-ModuleProject',
                    'New-VaultProject'
                )
            }
            PowerShellGetFormatVersion = ''
            ReleaseNotes               = 'https://github.com/techthoughts2/Catesta/blob/main/.github/CHANGELOG.md'
            Dependencies               = @(
                @{
                    Name           = 'Plaster'
                    MinimumVersion = '1.1.3'
                }
                @{
                    Name           = 'Pester'
                    MinimumVersion = '4.10.1'
                }
                @{
                    Name           = 'InvokeBuild'
                    MinimumVersion = '5.8.0'
                }
                @{
                    Name           = 'PSScriptAnalyzer'
                    MinimumVersion = '1.19.1'
                }
                @{
                    Name           = 'platyPS'
                    MinimumVersion = '0.12.0'
                }
            )
            RepositorySourceLocation   = 'https://www.powershellgallery.com/api/v2/'
            Repository                 = 'PSGallery'
            PackageManagementProvider  = 'NuGet'
            AdditionalMetadata         = @{
                summary                   = 'Catesta is a PowerShell module project generator. It uses templates to rapidly scaffold test and build integration for a variety of CI/CD platforms.'
                requireLicenseAcceptance  = 'False'
                SourceName                = 'PSGallery'
                versionDownloadCount      = '39'
                copyright                 = '(c) Jake Morrison. All rights reserved.'
                published                 = [datetime]'2/18/2023 11:09:54 PM +00:00'
                PowerShellVersion         = '5.1'
                FileList                  = 'Catesta.nuspec|Catesta.psd1|Catesta.psm1|en-US\Catesta-help.xml|Resources\AppVeyor\actions_bootstrap.ps1|Resources\AppVeyor\appveyor.yml|Resources\AWS\buildspec_powershell_windows.yml|Resources\AWS\buildspec_pwsh_linux.yml|Resources\AWS\buildspec_pwsh_windows.yml|Resources\AWS\configure_aws_credential.ps1|Resources\AWS\install_modules.ps1|Resources\Azure\actions_bootstrap.ps1|Resources\Azure\azure-pipelines.yml|Resources\AzureRepoFiles\pull_request_template.md|Resources\Bitbucket\actions_bootstrap.ps1|Resources\Bitbucket\bitbucket-pipelines.yml|Resources\GitHubActions\actions_bootstrap.ps1|Resources\GitHubFiles\PULL_REQUEST_TEMPLATE.md|Resources\GitLab\.gitlab-ci.yml|Resources\GitLab\actions_bootstrap.ps1|Resources\Module\plasterManifest.xml|Resources\Read_the_Docs\.readthedocs.yaml|Resources\Read_the_Docs\index.md|Resources\RepoFiles\agitignore|Resources\RepoFiles\CHANGELOG.md|Resources\RepoFiles\CODE_OF_CONDUCT.md|Resources\RepoFiles\CONTRIBUTING.md|Resources\RepoFiles\README.md|Resources\RepoFiles\SECURITY.md|Resources\Vault\plasterManifest.xml|Resources\AWS\CloudFormation\PowerShellCodeBuildCC.yml|Resources\AWS\CloudFormation\PowerShellCodeBuildGit.yml|Resources\Editor\VSCode\extensions.json|Resources\Editor\VSCode\settings.json|Resources\Editor\VSCode\tasks.json|Resources\GitHubActions\workflows\wf_Linux.yml|Resources\GitHubActions\workflows\wf_MacOS.yml|Resources\GitHubActions\workflows\wf_Windows.yml|Resources\GitHubActions\workflows\wf_Windows_Core.yml|Resources\GitHubFiles\ISSUE_TEMPLATE\bug-report.md|Resources\GitHubFiles\ISSUE_TEMPLATE\feature_request.md|Resources\GitLabFiles\issue_templates\bug-report.md|Resources\GitLabFiles\issue_templates\feature-request.md|Resources\GitLabFiles\merge_request_templates\Default.md|Resources\Module\src\PSModule.build.ps1|Resources\Module\src\PSModule.Settings.ps1|Resources\Module\src\PSScriptAnalyzerSettings.psd1|Resources\Read_the_Docs\material\mkdocs.yml|Resources\Read_the_Docs\material\requirements.txt|Resources\Read_the_Docs\readthedocs\mkdocs.yml|Resources\Read_the_Docs\readthedocs\requirements.txt|Resources\RepoFiles\Licences\APACHELICENSE|Resources\RepoFiles\Licences\GNULICENSE|Resources\RepoFiles\Licences\ISCLICENSE|Resources\RepoFiles\Licences\MITLICENSE|Resources\Vault\src\PSScriptAnalyzerSettings.psd1|Resources\Vault\src\PSVault.build.ps1|Resources\Vault\src\PSVault.Settings.ps1|Resources\Module\src\Module\Imports.ps1|Resources\Module\src\Module\Module.psm1|Resources\Vault\src\PSVault\PSVault.psm1|Resources\Module\src\Module\Private\Get-Day.ps1|Resources\Module\src\Module\Public\Get-HelloWorld.ps1|Resources\Vault\src\PSVault\PSVault.Extension\PSVault.Extension.psd1|Resources\Vault\src\PSVault\PSVault.Extension\PSVault.Extension.psm1|Resources\Module\src\Tests\v4\Integration\SampleIntegrationTest.Tests.ps1|Resources\Module\src\Tests\v4\Unit\ExportedFunctions.Tests.ps1|Resources\Module\src\Tests\v4\Unit\PSModule-Module.Tests.ps1|Resources\Module\src\Tests\v5\Integration\SampleIntegrationTest.Tests.ps1|Resources\Module\src\Tests\v5\Unit\ExportedFunctions.Tests.ps1|Resources\Module\src\Tests\v5\Unit\PSModule-Module.Tests.ps1|Resources\Vault\src\Tests\v4\Unit\ExportedFunctions.Tests.ps1|Resources\Vault\src\Tests\v4\Unit\Module-Function.Tests.ps1|Resources\Vault\src\Tests\v4\Unit\PSVault-Module.Tests.ps1|Resources\Vault\src\Tests\v5\Unit\ExportedFunctions.Tests.ps1|Resources\Vault\src\Tests\v5\Unit\Module-Function.Tests.ps1|Resources\Vault\src\Tests\v5\Unit\PSVault-Module.Tests.ps1|Resources\Module\src\Tests\v4\Unit\Private\Private-Function.Tests.ps1|Resources\Module\src\Tests\v4\Unit\Public\Public-Function.Tests.ps1|Resources\Module\src\Tests\v5\Unit\Private\Private-Function.Tests.ps1|Resources\Module\src\Tests\v5\Unit\Public\Public-Function.Tests.ps1'
                tags                      = 'Actions AppVeyor AWS AWS-CodeBuild Azure AzureDevOps Azure-DevOps AzureRepos Bitbucket BitbucketPipelines CI CICD CICDPipeline CodeBuild CodeCommit Cross-Platform CrossPlatform CrossPlatformDevelopment GitHub GitHub-Actions GitHubWorkflow GitLab GitLabPipeline GitLab-Runner Extension Linux MacOS Module Modules MultiCloud Plaster PowerShell PowerShellModule Project pwsh ReadtheDocs Scaffold Secret SecretVault Secrets Template Vault Windows PSModule'
                lastUpdated               = '4/5/2023 6:54:12 PM +01:00'
                ItemType                  = 'Module'
                packageSize               = '110425'
                title                     = 'Catesta'
                PackageManagementProvider = 'NuGet'
                created                   = [datetime]'2/18/2023 11:09:54 PM +00:00'
                description               = 'Catesta is a PowerShell module project generator. It uses templates to rapidly scaffold test and build integration for a variety of CI/CD platforms.'
                isAbsoluteLatestVersion   = 'True'
                developmentDependency     = 'False'
                CompanyName               = 'TechThoughts'
                NormalizedVersion         = '2.0.0'
                IsPrerelease              = 'false'
                Functions                 = 'New-ModuleProject New-VaultProject'
                releaseNotes              = 'https://github.com/techthoughts2/Catesta/blob/main/docs/CHANGELOG.md'
                downloadCount             = '1186'
                updated                   = [datetime]'2023-04-05T18:54:12Z'
                isLatestVersion           = 'True'
                Authors                   = 'Jake Morrison'
                GUID                      = '6796b193-9013-468a-b022-837749af2d06'
            }
            ModuleSize                 = '401515'
            ModuleFileCount            = '80'
            ProjectInfo                = @{
                GitStatus   = 'True'
                StarCount   = '132'
                Subscribers = '5'
                Watchers    = '132'
                Created     = [datetime]'12/02/19 19:00:22'
                Updated     = [datetime]'03/29/23 17:45:54'
                Forks       = '13'
                License     = 'MIT License'
                Issues      = '5'
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
            ModuleSize                 = '28674'
            ModuleFileCount            = '2'
        } #objData3
        #github - corp
        $objData4 = [PSCustomObject]@{
            Name                       = 'AWS.Tools.Common'
            Version                    = [version]'4.1.308'
            Type                       = 'Module'
            Description                = @'
The AWS Tools for PowerShell lets developers and administrators manage their AWS services from the PowerShell scripting environment. In order to manage each AWS service, install the corresponding module (e.g. AWS.Tools.EC2, AWS.Tools.S3...).
The module AWS.Tools.Installer (https://www.powershellgallery.com/packages/AWS.Tools.Installer/) makes it easier to install, update and uninstall the AWS.Tools modules.
This version of AWS Tools for PowerShell is compatible with Windows PowerShell 5.1+ and PowerShell Core 6+ on Windows, Linux and macOS. When running on Windows PowerShell, .NET Framework 4.7.2 or newer is required.
Alternative modules, AWSPowerShell.NetCore and AWSPowerShell, provide support for all AWS services from a single module and also support older versions of Windows PowerShell and .NET Framework.
'@
            Author                     = 'Amazon.com Inc'
            CompanyName                = 'aws-dotnet-sdk-team'
            Copyright                  = 'Copyright 2012-2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.'
            PublishedDate              = [datetime]'04/06/23 16:25:24'
            InstalledDate              = ''
            UpdatedDate                = ''
            LicenseUri                 = 'https://aws.amazon.com/apache-2-0/'
            ProjectUri                 = 'https://github.com/aws/aws-tools-for-powershell'
            IconUri                    = 'https://sdk-for-net.amazonwebservices.com/images/AWSLogo128x128.png'
            Tags                       = @(
                'AWS',
                'cloud',
                'Windows',
                'PSEdition_Desktop',
                'PSEdition_Core',
                'Linux',
                'MacOS',
                'Mac',
                'PSModule'
            )
            Includes                   = @{
                Cmdlet         = @(
                    'Clear-AWSHistory',
                    'Set-AWSHistoryConfiguration',
                    'Initialize-AWSDefaultConfiguration',
                    'Clear-AWSDefaultConfiguration',
                    'Get-AWSPowerShellVersion',
                    'New-AWSCredential',
                    'Set-AWSCredential',
                    'Clear-AWSCredential',
                    'Get-AWSCredential',
                    'Set-AWSSamlEndpoint',
                    'Set-AWSSamlRoleProfile',
                    'Get-AWSService',
                    'Get-AWSCmdletName',
                    'Add-AWSLoggingListener',
                    'Remove-AWSLoggingListener',
                    'Set-AWSResponseLogging',
                    'Enable-AWSMetricsLogging',
                    'Disable-AWSMetricsLogging',
                    'Set-AWSProxy',
                    'Clear-AWSProxy',
                    'Get-AWSPublicIpAddressRange',
                    'Set-DefaultAWSRegion',
                    'Clear-DefaultAWSRegion',
                    'Get-DefaultAWSRegion',
                    'Get-AWSRegion',
                    'Remove-AWSCredentialProfile'
                )
                DscResource    = '{}'
                RoleCapability = '{}'
                Command        = @(
                    'Clear-AWSHistory',
                    'Set-AWSHistoryConfiguration',
                    'Initialize-AWSDefaultConfiguration',
                    'Clear-AWSDefaultConfiguration',
                    'Get-AWSPowerShellVersion',
                    'New-AWSCredential',
                    'Set-AWSCredential',
                    'Clear-AWSCredential',
                    'Get-AWSCredential',
                    'Set-AWSSamlEndpoint',
                    'Set-AWSSamlRoleProfile',
                    'Get-AWSService',
                    'Get-AWSCmdletName',
                    'Add-AWSLoggingListener',
                    'Remove-AWSLoggingListener',
                    'Set-AWSResponseLogging',
                    'Enable-AWSMetricsLogging',
                    'Disable-AWSMetricsLogging',
                    'Set-AWSProxy',
                    'Clear-AWSProxy',
                    'Get-AWSPublicIpAddressRange',
                    'Set-DefaultAWSRegion',
                    'Clear-DefaultAWSRegion',
                    'Get-DefaultAWSRegion',
                    'Get-AWSRegion',
                    'Remove-AWSCredentialProfile'
                )
            }
            PowerShellGetFormatVersion = ''
            ReleaseNotes               = 'https://github.com/aws/aws-tools-for-powershell/blob/main/CHANGELOG.md'
            Dependencies               = '{}'
            RepositorySourceLocation   = 'https://www.powershellgallery.com/api/v2/'
            Repository                 = 'PSGallery'
            PackageManagementProvider  = 'NuGet'
            AdditionalMetadata         = @{
                summary                   = @'
The AWS Tools for PowerShell lets developers and administrators manage their AWS services from the PowerShell scripting environment. In order to manage each AWS service, install the corresponding module (e.g. AWS.Tools.EC2, AWS.Tools.S3...).
The module AWS.Tools.Installer (https://www.powershellgallery.com/packages/AWS.Tools.Installer/) makes it easier to install, update and uninstall the AWS.Tools modules.
This version of AWS Tools for PowerShell is compatible with Windows PowerShell 5.1+ and PowerShell Core 6+ on Windows, Linux and macOS. When running on Windows PowerShell, .NET Framework 4.7.2 or newer is required.
Alternative modules, AWSPowerShell.NetCore and AWSPowerShell, provide support for all AWS services from a single module and also support older versions of Windows PowerShell and .NET Framework.
'@
                requireLicenseAcceptance  = 'False'
                SourceName                = 'PSGallery'
                versionDownloadCount      = '7'
                copyright                 = 'Copyright 2012-2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.'
                published                 = [datetime]'4/6/2023 10:25:24 PM +01:00'
                PowerShellVersion         = '5.1'
                FileList                  = 'AWS.Tools.Common.nuspec|aws-crt-auth.dll|aws-crt-checksums.dll|aws-crt-http.dll|aws-crt.dll|AWS.Tools.Common.Aliases.psm1|AWS.Tools.Common.Completers.psm1|AWS.Tools.Common.dll|AWS.Tools.Common.dll-Help.xml|AWS.Tools.Common.Format.ps1xml|AWS.Tools.Common.psd1|AWS.Tools.Common.XML|AWSSDK.Core.dll|AWSSDK.Extensions.CrtIntegration.dll|AWSSDK.SecurityToken.dll|ImportGuard.ps1|LICENSE|NOTICE'
                DotNetFrameworkVersion    = '4.7.2'
                lastUpdated               = [datetime]'4/6/2023 10:34:20 PM +01:00'
                ItemType                  = 'Module'
                packageSize               = '4984717'
                title                     = 'AWS.Tools.Common'
                PackageManagementProvider = 'NuGet'
                created                   = [datetime]'4/6/2023 10:25:24 PM +01:00'
                description               = @'
The AWS Tools for PowerShell lets developers and administrators manage their AWS services from the PowerShell scripting environment. In order to manage each AWS service, install the corresponding module (e.g. AWS.Tools.EC2, AWS.Tools.S3...).
The module AWS.Tools.Installer (https://www.powershellgallery.com/packages/AWS.Tools.Installer/) makes it easier to install, update and uninstall the AWS.Tools modules.
This version of AWS Tools for PowerShell is compatible with Windows PowerShell 5.1+ and PowerShell Core 6+ on Windows, Linux and macOS. When running on Windows PowerShell, .NET Framework 4.7.2 or newer is required.
Alternative modules, AWSPowerShell.NetCore and AWSPowerShell, provide support for all AWS services from a single module and also support older versions of Windows PowerShell and .NET Framework.
'@
                isAbsoluteLatestVersion   = 'True'
                developmentDependency     = 'False'
                CompanyName               = 'Amazon.com, Inc'
                NormalizedVersion         = '4.1.308'
                IsPrerelease              = 'false'
                releaseNotes              = 'https://github.com/aws/aws-tools-for-powershell/blob/master/CHANGELOG.md'
                Cmdlets                   = 'Clear-AWSHistory Set-AWSHistoryConfiguration Initialize-AWSDefaultConfiguration Clear-AWSDefaultConfiguration Get-AWSPowerShellVersion New-AWSCredential Set-AWSCredential Clear-AWSCredential Get-AWSCredential Set-AWSSamlEndpoint Set-AWSSamlRoleProfile Get-AWSService Get-AWSCmdletName Add-AWSLoggingListener Remove-AWSLoggingListener Set-AWSResponseLogging Enable-AWSMetricsLogging Disable-AWSMetricsLogging Set-AWSProxy Clear-AWSProxy Get-AWSPublicIpAddressRange Set-DefaultAWSRegion Clear-DefaultAWSRegion Get-DefaultAWSRegion Get-AWSRegion Remove-AWSCredentialProfile'
                tags                      = 'AWS cloud Windows PSEdition_Desktop PSEdition_Core Linux MacOS Mac PSModule'
                downloadCount             = '13189567'
                updated                   = '2023-04-06T22:34:20Z'
                isLatestVersion           = 'True'
                Authors                   = 'Amazon.com Inc'
                GUID                      = 'e5b05bf3-9eee-47b2-81f2-41ddc0501b86'
            }
            ModuleSize                 = '13231730'
            ModuleFileCount            = '17'
            ProjectInfo                = @{
                GitStatus   = 'True'
                StarCount   = '209'
                Subscribers = '28'
                Watchers    = '209'
                Created     = [datetime]'03/26/19 17:41:43'
                Updated     = [datetime]'03/30/23 10:14:06'
                Forks       = '75'
                License     = 'Apache License 2.0'
                Issues      = '23'
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

    Describe 'Find-ModuleByCommand' -Tag Unit {
        BeforeEach {
            $script:glData = $dataSet
            Mock -CommandName Import-XMLDataSet -MockWith {
                $true
            }
        } #before_each

        Context 'Error' {

            It 'should return null if the dataset can not be loaded' {
                Mock -CommandName Import-XMLDataSet -MockWith {
                    $false
                }
                Find-ModuleByCommand -CommandName 'Send-TelegramTextMessage' | Should -BeNullOrEmpty
            } #it

        } #context_Error

        Context 'Success' {


            It 'should support the InSightview parameter' {
                $eval = Find-ModuleByCommand -CommandName 'Send-TelegramTextMessage' -InSightview
                $eval.Name | Should -BeExactly 'PoshGram'
            } #it


            It 'should return expected results when it finds a module containing the command' {
                $eval = Find-ModuleByCommand -CommandName 'Send-TelegramTextMessage'
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeExactly 1
                $eval.Name | Should -BeExactly 'PoshGram'
            } #it

            It 'should return expected results when it does not find a module containing the command' {
                Find-ModuleByCommand -CommandName 'New-CommandName' | Should -BeNullOrEmpty
            } #it

            # It 'should return expected results when no options are specified with everything included' {
            #     $eval = Find-ModuleByCommand -IncludeCorps -IncludeRegulars
            #     $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
            #     $count | Should -BeExactly 4
            #     $eval[0].Name | Should -BeExactly 'PSLogging'
            # } #it

        } #context_Success

    } #describe_Find-ModuleByCommand

} #inModule
