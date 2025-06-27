BeforeDiscovery {
    Set-Location -Path $PSScriptRoot
    $ModuleName = 'PSGalleryExplorer'
    $PathToManifest = [System.IO.Path]::Combine('..', '..', 'Artifacts', "$ModuleName.psd1")
    #if the module is already in memory, remove it
    Get-Module $ModuleName -ErrorAction SilentlyContinue | Remove-Module -Force
    Import-Module $PathToManifest -Force
}

Describe 'Integration Tests' -Tag Integration {

    Context -Name 'Find-PSGModule' {

        Context 'General' {

            It 'should support the InSightview parameter' {
                $eval = Find-PSGModule -ByName 'pwshBedrock' -InSightview
                $eval.Name | Should -BeExactly 'pwshBedrock'
            } #it

            It 'should have the ModuleSize property' {
                $eval = Find-PSGModule -ByName 'pwshBedrock'
                $eval.ModuleSize | Should -BeGreaterThan 0
            } #it

            It 'should have the ModuleFileCount property' {
                $eval = Find-PSGModule -ByName 'pwshBedrock'
                $eval.ModuleFileCount | Should -BeGreaterThan 0
            } #it

            It 'should have the Dependency property populated' {
                $eval = Find-PSGModule -ByName 'pwshBedrock'
                $eval.Dependencies.Count | Should -BeGreaterThan 3
            } #it

        } #context_General

        Context 'ByDownloads' {

            It 'should return expected results when finding finding default downloads' {
                $eval = Find-PSGModule -ByDownloads -NumberToReturn 10000
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeGreaterThan 1
                $eval.Name | Should -Not -Contain 'PSLogging'
                $eval.Name | Should -Not -Contain 'AWS.Tools.Common'
                $eval.Name | Should -Contain 'PoshGram'
            } #it

            It 'should return expected results when finding downloads with corp included' {
                $eval = Find-PSGModule -ByDownloads -IncludeCorps -NumberToReturn 10000
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeGreaterThan 1
                $eval.Name | Should -Not -Contain 'PSLogging'
                $eval.Name | Should -Contain 'AWS.Tools.Common'
                $eval.Name | Should -Contain 'PoshGram'
            } #it

            It 'should return expected results when finding downloads with popular included' {
                $eval = Find-PSGModule -ByDownloads -IncludeRegulars -NumberToReturn 10000
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeGreaterThan 1
                $eval.Name | Should -Contain 'PSLogging'
                $eval.Name | Should -Not -Contain 'AWS.Tools.Common'
                $eval.Name | Should -Contain 'PoshGram'
            } #it

            It 'should return expected results when finding downloads with everything included' {
                $eval = Find-PSGModule -ByDownloads -IncludeRegulars -IncludeCorps -NumberToReturn 10000
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeGreaterThan 1
                $eval.Name | Should -Contain 'PSLogging'
                $eval.Name | Should -Contain 'AWS.Tools.Common'
                $eval.Name | Should -Contain 'PoshGram'
            } #it

        } #context_ByDownloads

        Context 'ByRepoInfo' {

            It 'should return expected results when finding default Repository StarCount' {
                $eval = Find-PSGModule -ByRepoInfo StarCount -NumberToReturn 10000
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeGreaterThan 1
                $eval.Name | Should -Not -Contain 'PSLogging'
                $eval.Name | Should -Not -Contain 'AWS.Tools.Common'
                $eval.Name | Should -Contain 'PoshGram'
            } #it

            It 'should return expected results when finding Repository StarCount with corp included' {
                $eval = Find-PSGModule -ByRepoInfo StarCount -IncludeCorps -NumberToReturn 10000
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeGreaterThan 1
                $eval.Name | Should -Not -Contain 'PSLogging'
                $eval.Name | Should -Contain 'AWS.Tools.Common'
                $eval.Name | Should -Contain 'PoshGram'
            } #it

            It 'should return expected results when finding Repository StarCount with popular included' {
                $eval = Find-PSGModule -ByRepoInfo StarCount -IncludeRegulars -NumberToReturn 10000
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeGreaterThan 1
                $eval.Name | Should -Contain 'Pester'
                $eval.Name | Should -Not -Contain 'PSLogging'
                $eval.Name | Should -Not -Contain 'AWS.Tools.Common'
                $eval.Name | Should -Contain 'PoshGram'
            } #it

            It 'should return expected results when finding Repository StarCount with everything included' {
                $eval = Find-PSGModule -ByRepoInfo StarCount -IncludeRegulars -IncludeCorps -NumberToReturn 10000
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeGreaterThan 1
                $eval.Name | Should -Contain 'Pester'
                $eval.Name | Should -Not -Contain 'PSLogging'
                $eval.Name | Should -Contain 'AWS.Tools.Common'
                $eval.Name | Should -Contain 'PoshGram'
            } #it

            It 'should return expected results when finding default Repository Subscribers' {
                $eval = Find-PSGModule -ByRepoInfo Subscribers
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeExactly 35
            } #it

            It 'should return expected results when finding default Repository Issues' {
                $eval = Find-PSGModule -ByRepoInfo Issues
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeExactly 35
            } #it

            It 'should return expected results when finding default Repository Forks' {
                $eval = Find-PSGModule -ByRepoInfo Forks
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeExactly 35
            } #it

        } #context_ByRepoInfo

        Context 'ByRecentUpdate' {

            It 'should return expected results when finding recent default gallery updates' {
                $eval = Find-PSGModule -ByRecentUpdate GalleryUpdate
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeExactly 35
            } #it

            It 'should return expected results when finding recent gallery updates with corp included' {
                $eval = Find-PSGModule -ByRecentUpdate GalleryUpdate -IncludeCorps
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeExactly 35
            } #it

            It 'should return expected results when finding recent gallery updates with popular included' {
                $eval = Find-PSGModule -ByRecentUpdate GalleryUpdate -IncludeRegulars
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeExactly 35
            } #it

            It 'should return expected results when finding recent gallery updates with everything included' {
                $eval = Find-PSGModule -ByRecentUpdate GalleryUpdate -IncludeRegulars -IncludeCorps
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeExactly 35
            } #it

            It 'should return expected results when finding Repository default updates' {
                $eval = Find-PSGModule -ByRecentUpdate RepoUpdate
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeExactly 35
            } #it


        } #context_ByRecentUpdate

        Context 'ByRandom' {

            It 'should return expected results when finding default random' {
                $eval = Find-PSGModule -ByRandom
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeExactly 35
            } #it

            It 'should return expected results when finding random with corp included' {
                $eval = Find-PSGModule -ByRandom -IncludeCorps
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeExactly 35
            } #it

            It 'should return expected results when finding random with popular included' {
                $eval = Find-PSGModule -ByRandom -IncludeRegulars
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeExactly 35
            } #it

            It 'should return expected results when finding random with everything included' {
                $eval = Find-PSGModule -ByRandom -IncludeRegulars -IncludeCorps
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeExactly 35
            } #it

        } #context_ByRandom

        Context 'ByName' {

            It 'should return null when the module name is not found' {
                Find-PSGModule -ByName ModuleNoExist | Should -BeNullOrEmpty
            } #it

            It 'should return expected results when finding module name on default' {
                $eval = Find-PSGModule -ByName 'PoshGram'
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeExactly 1
                $eval.Name | Should -BeExactly 'PoshGram'
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

            It 'should return expected results when finding module name with wild card' {
                $eval = Find-PSGModule -ByName 'PoshGr*' -IncludeRegulars -IncludeCorps
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeGreaterOrEqual 1
            } #it

        } #context_ByName

        Context 'ByTag' {

            It 'should return null when the module is not found' {
                Find-PSGModule -ByTag ModuleNoExist | Should -BeNullOrEmpty
            } #it

            It 'should return expected results when finding module tag on default' {
                $eval = Find-PSGModule -ByTag 'telegram'
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeGreaterOrEqual 1
            } #it

            It 'should return expected results when finding module tag with corp included' {
                $eval = Find-PSGModule -ByTag 'AWS' -IncludeCorps
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeGreaterThan 1
            } #it

            It 'should return expected results when finding module tag with popular included' {
                $eval = Find-PSGModule -ByTag 'Logging' -IncludeRegulars
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeGreaterThan 1
            } #it

            It 'should return expected results when finding module tag with everything included' {
                $eval = Find-PSGModule -ByTag 'PowerShell' -IncludeRegulars -IncludeCorps
                $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                $count | Should -BeGreaterThan 1
            } #it

        } #context_ByTag

        Context 'Everything' {

            Context 'Success' {

                It 'should return expected results when no options are specified' {
                    $eval = Find-PSGModule
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeGreaterOrEqual 4000
                } #it

                It 'should return expected results when no options are specified with everything included' {
                    $eval = Find-PSGModule -IncludeCorps -IncludeRegulars
                    $count = $eval | Measure-Object | Select-Object -ExpandProperty Count
                    $count | Should -BeGreaterOrEqual 5000
                } #it

            } #context_Success

        } #context_everything

    } #context_Find-PSGModule

    Context -Name 'Find-ModuleByCommand' {

        It 'should return null when the command is not found' {
            $guid = [guid]::NewGuid()
            Find-ModuleByCommand -CommandName "$guid" | Should -BeNullOrEmpty
        } #it

        It 'should return expected results when finding command name' {
            $eval = Find-ModuleByCommand -CommandName 'Send-TelegramTextMessage'
            $eval.Name | Should -Contain 'PoshGram'
        } #it

        It 'should support the InSightview parameter' {
            $eval = Find-ModuleByCommand -CommandName 'Send-TelegramTextMessage' -InSightview
            $eval.Name | Should -BeExactly 'PoshGram'
        } #it

    } #context_Find-ModuleByCommand

} #describe
