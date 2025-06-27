BeforeDiscovery {
    Set-Location -Path $PSScriptRoot
    $ModuleName = 'PSGalleryExplorer'
    $PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
    #if the module is already in memory, remove it
    Get-Module $ModuleName -ErrorAction SilentlyContinue | Remove-Module -Force
    Import-Module $PathToManifest -Force
}

InModuleScope 'PSGalleryExplorer' {

    Describe 'Import-XMLDataSet' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #before_all

        BeforeEach {
            $xmlData = @'
<Objs Version="1.1.0.1" xmlns="http://schemas.microsoft.com/powershell/2004/04">
  <Obj RefId="0">
    <TN RefId="0">
      <T>Asset</T>
      <T>Deserialized.Microsoft.PowerShell.Commands.PSRepositoryItemInfo</T>
      <T>Deserialized.System.Management.Automation.PSCustomObject</T>
      <T>Deserialized.System.Object</T>
    </TN>
    <MS>
      <S N="Name">PoshGram</S>
      <S N="Version">1.10.1</S>
      <S N="Type">Module</S>
      <S N="Description">PoshGram provides functionality to send various message types to a specified Telegram chat via the Telegram Bot API. Seperate PowerShell functions are used for each message type. Checks are included to ensure that file extensions, and file size restrictions are adhered to based on Telegram requirements.</S>
      <S N="Author">Jake Morrison</S>
      <S N="CompanyName">jakewmorrison</S>
      <S N="Copyright">(c) 2019 Jake Morrison. All rights reserved.</S>
      <DT N="PublishedDate">2019-12-18T07:05:48+00:00</DT>
      <Nil N="InstalledDate" />
      <Nil N="UpdatedDate" />
      <Nil N="LicenseUri" />
      <URI N="ProjectUri">https://github.com/techthoughts2/PoshGram</URI>
      <URI N="IconUri">https://github.com/techthoughts2/PoshGram/raw/main/media/PoshGram.png</URI>
      <Obj N="Tags" RefId="1">
        <TN RefId="1">
          <T>Deserialized.System.Object[]</T>
          <T>Deserialized.System.Array</T>
          <T>Deserialized.System.Object</T>
        </TN>
        <LST>
          <S>Animations</S>
          <S>Audio</S>
          <S>Automation</S>
          <S>bot</S>
          <S>Contact</S>
          <S>Contacts</S>
          <S>Coordinates</S>
          <S>Documents</S>
          <S>Gif</S>
          <S>Gifs</S>
          <S>Location</S>
          <S>Media</S>
          <S>Message</S>
          <S>Messaging</S>
          <S>Messenger</S>
          <S>Notification</S>
          <S>Notifications</S>
          <S>Notify</S>
          <S>Photo</S>
          <S>Photos</S>
          <S>Pictures</S>
          <S>Poll</S>
          <S>powershell</S>
          <S>powershell-module</S>
          <S>PSModule</S>
          <S>Send</S>
          <S>SM</S>
          <S>Sticker</S>
          <S>Stickers</S>
          <S>Sticker-Pack</S>
          <S>telegram</S>
          <S>telegram-bot-api</S>
          <S>telegramx</S>
          <S>Telegram-Sticker</S>
          <S>Telegram-Bot</S>
          <S>Venue</S>
          <S>Video</S>
          <S>Videos</S>
        </LST>
      </Obj>
      <Obj N="Includes" RefId="2">
        <TN RefId="2">
          <T>Deserialized.System.Collections.Hashtable</T>
          <T>Deserialized.System.Object</T>
        </TN>
        <DCT>
          <En>
            <S N="Key">DscResource</S>
            <Obj N="Value" RefId="3">
              <TNRef RefId="1" />
              <LST />
            </Obj>
          </En>
          <En>
            <S N="Key">Function</S>
            <Obj N="Value" RefId="4">
              <TNRef RefId="1" />
              <LST>
                <S>Get-TelegramStickerPackInfo</S>
                <S>Send-TelegramContact</S>
                <S>Send-TelegramLocalAnimation</S>
                <S>Send-TelegramLocalAudio</S>
                <S>Send-TelegramLocalDocument</S>
                <S>Send-TelegramLocalPhoto</S>
                <S>Send-TelegramLocalSticker</S>
                <S>Send-TelegramLocalVideo</S>
                <S>Send-TelegramLocation</S>
                <S>Send-TelegramMediaGroup</S>
                <S>Send-TelegramPoll</S>
                <S>Send-TelegramSticker</S>
                <S>Send-TelegramTextMessage</S>
                <S>Send-TelegramURLAnimation</S>
                <S>Send-TelegramURLAudio</S>
                <S>Send-TelegramURLDocument</S>
                <S>Send-TelegramURLPhoto</S>
                <S>Send-TelegramURLSticker</S>
                <S>Send-TelegramURLVideo</S>
                <S>Send-TelegramVenue</S>
                <S>Test-BotToken</S>
              </LST>
            </Obj>
          </En>
          <En>
            <S N="Key">Workflow</S>
            <Ref N="Value" RefId="3" />
          </En>
          <En>
            <S N="Key">Cmdlet</S>
            <Ref N="Value" RefId="3" />
          </En>
          <En>
            <S N="Key">Command</S>
            <Obj N="Value" RefId="5">
              <TNRef RefId="1" />
              <LST>
                <S>Get-TelegramStickerPackInfo</S>
                <S>Send-TelegramContact</S>
                <S>Send-TelegramLocalAnimation</S>
                <S>Send-TelegramLocalAudio</S>
                <S>Send-TelegramLocalDocument</S>
                <S>Send-TelegramLocalPhoto</S>
                <S>Send-TelegramLocalSticker</S>
                <S>Send-TelegramLocalVideo</S>
                <S>Send-TelegramLocation</S>
                <S>Send-TelegramMediaGroup</S>
                <S>Send-TelegramPoll</S>
                <S>Send-TelegramSticker</S>
                <S>Send-TelegramTextMessage</S>
                <S>Send-TelegramURLAnimation</S>
                <S>Send-TelegramURLAudio</S>
                <S>Send-TelegramURLDocument</S>
                <S>Send-TelegramURLPhoto</S>
                <S>Send-TelegramURLSticker</S>
                <S>Send-TelegramURLVideo</S>
                <S>Send-TelegramVenue</S>
                <S>Test-BotToken</S>
              </LST>
            </Obj>
          </En>
          <En>
            <S N="Key">RoleCapability</S>
            <Ref N="Value" RefId="3" />
          </En>
        </DCT>
      </Obj>
      <Nil N="PowerShellGetFormatVersion" />
      <S N="ReleaseNotes">1.10.1:_x000D__x000A_    Fixed bug where DisableNotification had no effect when running Send-TelegramSticker_x000D__x000A_1.10.0:_x000D__x000A_    Improved Help Formatting_x000D__x000A_    Added Send-TelegramURLSticker_x000D__x000A_    Added Send-TelegramLocalSticker_x000D__x000A_    Added Send-TelegramSticker_x000D__x000A_    Added Get-TelegramStickerPackInfo_x000D__x000A_    Added Send-TelegramPoll_x000D__x000A_    Added Send-TelegramVenue_x000D__x000A_    Added Send-TelegramContact_x000D__x000A_    DisableNotification and Streaming parameters changed from bool to switch on all functions_x000D__x000A_    Send-TelegramTextMessage: Preview parameter renamed to DisablePreview and changed from bool to switch_x000D__x000A_    Unit test and Infra test improvements_x000D__x000A_1.0.2 :_x000D__x000A_    Addressed bug where certain UTF-8 characters would fail to send properly in Send-TelegramTextMessage_x000D__x000A_    Cosmetic code change for Invoke functions to use splat parameters_x000D__x000A_1.0.0 :_x000D__x000A_    Addressed bug in Send-TelegramTextMessage that wasnt handling underscores_x000D__x000A_    Added code to support AWS Codebuild_x000D__x000A_0.9.0 :_x000D__x000A_    Restructured module for CI/CD Workflow_x000D__x000A_    Added Invoke-Build capabilities to module_x000D__x000A_    Added Animation functionality:_x000D__x000A_        Send-TelegramLocalAnimation_x000D__x000A_        Send-TelegramURLAnimation_x000D__x000A_    Added location functionality:_x000D__x000A_        Send-TelegramLocation_x000D__x000A_    Added multi-media functionality:_x000D__x000A_        Send-TelegramMediaGroup_x000D__x000A_    Consolidated private support functions_x000D__x000A_    Code Logic improvements_x000D__x000A_0.8.4 Added IconURI to manifest_x000D__x000A_0.8.3 Initial beta release.</S>
      <Obj N="Dependencies" RefId="6">
        <TNRef RefId="1" />
        <LST />
      </Obj>
      <S N="RepositorySourceLocation">https://www.powershellgallery.com/api/v2</S>
      <S N="Repository">PSGallery</S>
      <S N="PackageManagementProvider">NuGet</S>
      <Obj N="AdditionalMetadata" RefId="7">
        <TN RefId="3">
          <T>Deserialized.System.Management.Automation.PSCustomObject</T>
          <T>Deserialized.System.Object</T>
        </TN>
        <MS>
          <S N="summary">PoshGram provides functionality to send various message types to a specified Telegram chat via the Telegram Bot API. Seperate PowerShell functions are used for each message type. Checks are included to ensure that file extensions, and file size restrictions are adhered to based on Telegram requirements.</S>
          <S N="ItemType">Module</S>
          <S N="CompanyName">Tech Thoughts</S>
          <S N="updated">2020-01-05T19:10:07Z</S>
          <S N="isLatestVersion">True</S>
          <S N="title">PoshGram</S>
          <S N="FileList">PoshGram.nuspec|PoshGram.psd1|PoshGram.psm1|asset\emoji.json|en-US\PoshGram-help.xml</S>
          <S N="IsPrerelease">false</S>
          <S N="copyright">(c) 2019 Jake Morrison. All rights reserved.</S>
          <S N="versionDownloadCount">1479</S>
          <S N="releaseNotes">1.10.1:_x000D__x000A_    Fixed bug where DisableNotification had no effect when running Send-TelegramSticker_x000D__x000A_1.10.0:_x000D__x000A_    Improved Help Formatting_x000D__x000A_    Added Send-TelegramURLSticker_x000D__x000A_    Added Send-TelegramLocalSticker_x000D__x000A_    Added Send-TelegramSticker_x000D__x000A_    Added Get-TelegramStickerPackInfo_x000D__x000A_    Added Send-TelegramPoll_x000D__x000A_    Added Send-TelegramVenue_x000D__x000A_    Added Send-TelegramContact_x000D__x000A_    DisableNotification and Streaming parameters changed from bool to switch on all functions_x000D__x000A_    Send-TelegramTextMessage: Preview parameter renamed to DisablePreview and changed from bool to switch_x000D__x000A_    Unit test and Infra test improvements_x000D__x000A_1.0.2 :_x000D__x000A_    Addressed bug where certain UTF-8 characters would fail to send properly in Send-TelegramTextMessage_x000D__x000A_    Cosmetic code change for Invoke functions to use splat parameters_x000D__x000A_1.0.0 :_x000D__x000A_    Addressed bug in Send-TelegramTextMessage that wasnt handling underscores_x000D__x000A_    Added code to support AWS Codebuild_x000D__x000A_0.9.0 :_x000D__x000A_    Restructured module for CI/CD Workflow_x000D__x000A_    Added Invoke-Build capabilities to module_x000D__x000A_    Added Animation functionality:_x000D__x000A_        Send-TelegramLocalAnimation_x000D__x000A_        Send-TelegramURLAnimation_x000D__x000A_    Added location functionality:_x000D__x000A_        Send-TelegramLocation_x000D__x000A_    Added multi-media functionality:_x000D__x000A_        Send-TelegramMediaGroup_x000D__x000A_    Consolidated private support functions_x000D__x000A_    Code Logic improvements_x000D__x000A_0.8.4 Added IconURI to manifest_x000D__x000A_0.8.3 Initial beta release.</S>
          <S N="lastUpdated">1/5/20 7:10:07 PM +00:00</S>
          <S N="Authors">Jake Morrison</S>
          <S N="PackageManagementProvider">NuGet</S>
          <S N="tags">Animations Audio Automation bot Contact Contacts Coordinates Documents Gif Gifs Location Media Message Messaging Messenger Notification Notifications Notify Photo Photos Pictures Poll powershell powershell-module PSModule Send SM Sticker Stickers Sticker-Pack telegram telegram-bot-api telegramx Telegram-Sticker Telegram-Bot Venue Video Videos</S>
          <S N="PowerShellVersion">6.1.0</S>
          <S N="developmentDependency">False</S>
          <S N="NormalizedVersion">1.10.1</S>
          <S N="requireLicenseAcceptance">False</S>
          <S N="GUID">277b92bc-0ea9-4659-8f6c-ed5a1dfdfda2</S>
          <S N="created">12/18/19 7:05:48 AM +00:00</S>
          <S N="description">PoshGram provides functionality to send various message types to a specified Telegram chat via the Telegram Bot API. Seperate PowerShell functions are used for each message type. Checks are included to ensure that file extensions, and file size restrictions are adhered to based on Telegram requirements.</S>
          <S N="published">12/18/19 7:05:48 AM +00:00</S>
          <S N="isAbsoluteLatestVersion">True</S>
          <S N="downloadCount">2421</S>
          <S N="SourceName">PSGallery</S>
          <S N="packageSize">87559</S>
          <S N="Functions">Get-TelegramStickerPackInfo Send-TelegramContact Send-TelegramLocalAnimation Send-TelegramLocalAudio Send-TelegramLocalDocument Send-TelegramLocalPhoto Send-TelegramLocalSticker Send-TelegramLocalVideo Send-TelegramLocation Send-TelegramMediaGroup Send-TelegramPoll Send-TelegramSticker Send-TelegramTextMessage Send-TelegramURLAnimation Send-TelegramURLAudio Send-TelegramURLDocument Send-TelegramURLPhoto Send-TelegramURLSticker Send-TelegramURLVideo Send-TelegramVenue Test-BotToken</S>
        </MS>
      </Obj>
      <Obj N="GitHubInfo" RefId="8">
        <TN RefId="4">
          <T>System.Collections.Specialized.OrderedDictionary</T>
          <T>System.Object</T>
        </TN>
        <DCT>
          <En>
            <S N="Key">StarCount</S>
            <I64 N="Value">28</I64>
          </En>
          <En>
            <S N="Key">Subscribers</S>
            <I64 N="Value">5</I64>
          </En>
          <En>
            <S N="Key">Watchers</S>
            <I64 N="Value">28</I64>
          </En>
          <En>
            <S N="Key">Created</S>
            <DT N="Value">2018-06-28T01:42:08Z</DT>
          </En>
          <En>
            <S N="Key">Updated</S>
            <DT N="Value">2020-01-01T06:27:11Z</DT>
          </En>
          <En>
            <S N="Key">Forks</S>
            <I64 N="Value">4</I64>
          </En>
          <En>
            <S N="Key">License</S>
            <S N="Value">MIT License</S>
          </En>
        </DCT>
      </Obj>
    </MS>
  </Obj>
</Objs>
<Objs Version="1.1.0.1" xmlns="http://schemas.microsoft.com/powershell/2004/04">
  <Obj RefId="0">
    <TN RefId="0">
      <T>Asset</T>
      <T>Deserialized.Microsoft.PowerShell.Commands.PSRepositoryItemInfo</T>
      <T>Deserialized.System.Management.Automation.PSCustomObject</T>
      <T>Deserialized.System.Object</T>
    </TN>
    <MS>
      <S N="Name">cRegFile</S>
      <S N="Version">1.2</S>
      <S N="Type">Module</S>
      <S N="Description">DSC resource which is designed to manage large numbers of registry settings (especially registry keys with many subkeys and values)._x000D__x000A__x000D__x000A_It uses :_x000D__x000A_.reg files to contain all the settings in a managed registry key_x000D__x000A_reg.exe to import and export .reg files_x000D__x000A_Get-FileHash to compare the contents of .reg files</S>
      <S N="Author">Mathieu Buisson</S>
      <S N="CompanyName">MathieuBuisson</S>
      <S N="Copyright">(c) 2016 Mathieu Buisson. All rights reserved.</S>
      <DT N="PublishedDate">2016-04-09T13:00:36+00:00</DT>
      <Nil N="InstalledDate" />
      <Nil N="UpdatedDate" />
      <Nil N="LicenseUri" />
      <URI N="ProjectUri">https://github.com/MathieuBuisson/Powershell-Administration/tree/main/cRegFile</URI>
      <Nil N="IconUri" />
      <Obj N="Tags" RefId="1">
        <TN RefId="1">
          <T>Deserialized.System.Object[]</T>
          <T>Deserialized.System.Array</T>
          <T>Deserialized.System.Object</T>
        </TN>
        <LST>
          <S>DesiredStateConfiguration</S>
          <S>DSC</S>
          <S>PSModule</S>
        </LST>
      </Obj>
      <Obj N="Includes" RefId="2">
        <TN RefId="2">
          <T>Deserialized.System.Collections.Hashtable</T>
          <T>Deserialized.System.Object</T>
        </TN>
        <DCT>
          <En>
            <S N="Key">DscResource</S>
            <Obj N="Value" RefId="3">
              <TNRef RefId="1" />
              <LST>
                <S>cRegFile</S>
              </LST>
            </Obj>
          </En>
          <En>
            <S N="Key">Function</S>
            <Obj N="Value" RefId="4">
              <TNRef RefId="1" />
              <LST>
                <S>Get-TargetResource</S>
                <S>Set-TargetResource</S>
                <S>Test-TargetResource</S>
              </LST>
            </Obj>
          </En>
          <En>
            <S N="Key">Workflow</S>
            <Obj N="Value" RefId="5">
              <TNRef RefId="1" />
              <LST />
            </Obj>
          </En>
          <En>
            <S N="Key">Cmdlet</S>
            <Ref N="Value" RefId="5" />
          </En>
          <En>
            <S N="Key">Command</S>
            <Obj N="Value" RefId="6">
              <TNRef RefId="1" />
              <LST>
                <S>Get-TargetResource</S>
                <S>Set-TargetResource</S>
                <S>Test-TargetResource</S>
              </LST>
            </Obj>
          </En>
          <En>
            <S N="Key">RoleCapability</S>
            <Ref N="Value" RefId="5" />
          </En>
        </DCT>
      </Obj>
      <Nil N="PowerShellGetFormatVersion" />
      <S N="ReleaseNotes">http://theshellnut.com/managing-large-numbers-of-registry-settings-with-powershell-dsc/</S>
      <Obj N="Dependencies" RefId="7">
        <TNRef RefId="1" />
        <LST />
      </Obj>
      <S N="RepositorySourceLocation">https://www.powershellgallery.com/api/v2</S>
      <S N="Repository">PSGallery</S>
      <S N="PackageManagementProvider">NuGet</S>
      <Obj N="AdditionalMetadata" RefId="8">
        <TN RefId="3">
          <T>Deserialized.System.Management.Automation.PSCustomObject</T>
          <T>Deserialized.System.Object</T>
        </TN>
        <MS>
          <S N="summary">DSC resource which is designed to manage large numbers of registry settings (especially registry keys with many subkeys and values)._x000D__x000A__x000D__x000A_It uses :_x000D__x000A_.reg files to contain all the settings in a managed registry key_x000D__x000A_reg.exe to import and export .reg files_x000D__x000A_Get-FileHash to compare the contents of .reg files</S>
          <S N="ItemType">Module</S>
          <S N="CompanyName">Unknown</S>
          <S N="updated">2020-01-02T16:12:16Z</S>
          <S N="isLatestVersion">True</S>
          <S N="title">cRegFile</S>
          <S N="FileList">cRegFile.nuspec|cRegFile.psd1|DSCResources\cRegFile\cRegFile.psm1|DSCResources\cRegFile\cRegFile.schema.mof|DSCResources\cRegFile\ResourceDesignerScripts\GeneratecRegFileSchema.ps1|SampleConfiguration\RemoteControlsConfig.ps1</S>
          <S N="IsPrerelease">false</S>
          <S N="copyright">(c) 2016 Mathieu Buisson. All rights reserved.</S>
          <S N="versionDownloadCount">2388</S>
          <S N="releaseNotes">http://theshellnut.com/managing-large-numbers-of-registry-settings-with-powershell-dsc/</S>
          <S N="lastUpdated">1/2/20 4:12:16 PM +00:00</S>
          <S N="Authors">Mathieu Buisson</S>
          <S N="DscResources">cRegFile</S>
          <S N="PackageManagementProvider">NuGet</S>
          <S N="tags">DesiredStateConfiguration DSC PSModule</S>
          <S N="PowerShellVersion">4.0</S>
          <S N="developmentDependency">False</S>
          <S N="NormalizedVersion">1.2.0</S>
          <S N="requireLicenseAcceptance">False</S>
          <S N="GUID">213880c2-8dda-4d76-b293-f34b0be3a266</S>
          <S N="created">4/9/16 1:00:36 PM +00:00</S>
          <S N="description">DSC resource which is designed to manage large numbers of registry settings (especially registry keys with many subkeys and values)._x000D__x000A__x000D__x000A_It uses :_x000D__x000A_.reg files to contain all the settings in a managed registry key_x000D__x000A_reg.exe to import and export .reg files_x000D__x000A_Get-FileHash to compare the contents of .reg files</S>
          <S N="published">4/9/16 1:00:36 PM +00:00</S>
          <S N="isAbsoluteLatestVersion">True</S>
          <S N="downloadCount">2420</S>
          <S N="SourceName">PSGallery</S>
          <S N="packageSize">8604</S>
          <S N="Functions">Get-TargetResource Set-TargetResource Test-TargetResource</S>
        </MS>
      </Obj>
      <Obj N="GitHubInfo" RefId="9">
        <TN RefId="4">
          <T>System.Collections.Specialized.OrderedDictionary</T>
          <T>System.Object</T>
        </TN>
        <DCT>
          <En>
            <S N="Key">StarCount</S>
            <I64 N="Value">4</I64>
          </En>
          <En>
            <S N="Key">Subscribers</S>
            <I64 N="Value">3</I64>
          </En>
          <En>
            <S N="Key">Watchers</S>
            <I64 N="Value">4</I64>
          </En>
          <En>
            <S N="Key">Created</S>
            <DT N="Value">2014-12-20T09:15:24Z</DT>
          </En>
          <En>
            <S N="Key">Updated</S>
            <DT N="Value">2019-06-12T09:32:14Z</DT>
          </En>
          <En>
            <S N="Key">Forks</S>
            <I64 N="Value">1</I64>
          </En>
          <En>
            <S N="Key">License</S>
            <Nil N="Value" />
          </En>
        </DCT>
      </Obj>
    </MS>
  </Obj>
</Objs>
'@
            $objData = [PSCustomObject]@{

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
                IconUri                    = 'https://github.com/techthoughts2/PoshGram/raw/main/media/PoshGram.png'
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
                    StarCount   = '28'
                    License     = 'MIT License'
                    Created     = [datetime]'06/28/18 01:42:08'
                    Updated     = [datetime]'01/01/20 06:27:11'
                }
            }
            Mock -CommandName Invoke-XMLDataCheck -MockWith {
                $true
            } #endMock
            Mock -CommandName Get-Content -MockWith {
                $xmlData
            } #endMock
            Mock -CommandName ConvertFrom-Clixml -MockWith {
                $objData
            } #endMock
        } #before_each

        Context 'Error' {

            It 'should return false if an error is encountered getting content from data file' {
                Mock -CommandName Get-Content -MockWith {
                    throw 'FakeError'
                } #endMock
                Import-XMLDataSet | Should -BeExactly $false
            } #it

        } #context_Error

        Context 'Success' {

            It 'should return false if Invoke-XMLDataCheck does not succeed' {
                Mock -CommandName Invoke-XMLDataCheck -MockWith {
                    $false
                } #endMock
                Import-XMLDataSet | Should -BeExactly $false
            } #it

            It 'should return true if the data is successfully imported' {
                Import-XMLDataSet | Should -BeExactly $true
            } #it

        } #context_Success

    } #describe_Import-XMLDataSet

} #inModule
