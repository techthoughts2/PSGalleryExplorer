BeforeDiscovery {
    Set-Location -Path $PSScriptRoot
    $ModuleName = 'PSGalleryExplorer'
    $PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
    #if the module is already in memory, remove it
    Get-Module $ModuleName -ErrorAction SilentlyContinue | Remove-Module -Force
    Import-Module $PathToManifest -Force
}

InModuleScope 'PSGalleryExplorer' {

    Describe 'Confirm-XMLDataSet' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #before_all

        BeforeEach {
            Mock -CommandName Test-Path -MockWith {
                $true
            } #endMock
            Mock -CommandName Get-Item -MockWith {
                [PSCustomObject]@{
                    Name            = 'AzModI.xml'
                    CreationTime    = [datetime]'01/06/20 21:17:21'
                    CreationTimeUtc = [datetime]'01/07/20 05:17:21'
                    LastAccessTime  = [datetime]'01/06/20 21:17:22'
                    LastWriteTime   = [datetime]'01/06/20 21:17:21'
                }
            } #endMock
            Mock -CommandName Get-Date -MockWith {
                [datetime]'01/06/20 21:17:22'
            } #endMock
            Mock -CommandName Confirm-MetadataUpdate -MockWith {
                $true
            } #endMock
        } #before_each

        Context 'Error' {

            It 'should return false if an error is encountered with Test-Path' {
                Mock -CommandName Test-Path -MockWith {
                    throw 'FakeError'
                } #endMock
                Confirm-XMLDataSet | Should -BeExactly $false
            } #it

            It 'should return false if an error is encountered with Get-Item' {
                Mock -CommandName Get-Item -MockWith {
                    throw 'FakeError'
                } #endMock
                Confirm-XMLDataSet | Should -BeExactly $false
            } #it

            It 'should return null false if no file information is returned from Get-Item' {
                Mock -CommandName Get-Item -MockWith { } #endMock
                Confirm-XMLDataSet | Should -BeExactly $false
            } #it

        } #context_Error

        Context 'Success' {

            It 'should return false if the data file is not found' {
                Mock -CommandName Test-Path -MockWith {
                    $false
                } #endMock
                Confirm-XMLDataSet | Should -BeExactly $false
            } #it

            It 'should return true if the file is found and is less than 9 days old' {
                Confirm-XMLDataSet | Should -BeExactly $true
            } #it

            It 'should return true if the data file is older than 9 days but the metadata file is current' {
                Mock -CommandName Get-Date -MockWith {
                    [datetime]'1/16/20 21:17:22'
                } #endMock
                Confirm-XMLDataSet | Should -BeExactly $true
            } #it

            It 'should return false if the data file is older than 9 days and the metadata file is also out of date' {
                Mock -CommandName Get-Date -MockWith {
                    [datetime]'1/16/20 21:17:22'
                } #endMock
                Mock -CommandName Confirm-MetadataUpdate -MockWith {
                    $false
                } #endMock
                Confirm-XMLDataSet | Should -BeExactly $false
            } #it

            It 'should check the metadata file if the data file is greater than 9 days old' {
                Mock -CommandName Get-Date -MockWith {
                    [datetime]'1/16/20 21:17:22'
                } #endMock
                Confirm-XMLDataSet
                Should -Invoke -CommandName Confirm-MetadataUpdate -Exactly 1
            } #it

        } #context_Success

    } #describe_Confirm-XMLDataSet

} #inModule
