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
    #-------------------------------------------------------------------------
    $WarningPreference = "SilentlyContinue"
    #-------------------------------------------------------------------------
    Describe 'Confirm-XMLDataSet' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #before_all
        BeforeEach {
            Mock -CommandName Test-Path -MockWith {
                $true
            } #endMock
            Mock -CommandName Get-ChildItem -MockWith {
                [PSCustomObject]@{
                    Name            = 'AzModI.xml'
                    CreationTime    = [datetime]'01/06/20 21:17:21'
                    CreationTimeUtc = [datetime]'01/07/20 05:17:21'
                    LastAccessTime  = [datetime]'01/06/20 21:17:22'
                }
            } #endMock
            Mock -CommandName Get-Date -MockWith {
                [datetime]'01/06/20 21:17:22'
            } #endMock
        } #before_each
        Context 'Error' {
            It 'should return false if an error is encountered with Test-Path' {
                Mock -CommandName Test-Path -MockWith {
                    throw 'FakeError'
                } #endMock
                Confirm-XMLDataSet | Should -BeExactly $false
            } #it
            It 'should return false if an error is encountered with Get-ChildItem' {
                Mock -CommandName Get-ChildItem -MockWith {
                    throw 'FakeError'
                } #endMock
                Confirm-XMLDataSet | Should -BeExactly $false
            } #it
            It 'should return null false if no file information is returned from Get-ChildItem' {
                Mock -CommandName Get-ChildItem -MockWith { } #endMock
                Confirm-XMLDataSet | Should -BeExactly $false
            } #it
        } #context_FunctionName
        Context 'Success' {
            It 'should return false if the data file is not found' {
                Mock -CommandName Test-Path -MockWith {
                    $false
                } #endMock
                Confirm-XMLDataSet | Should -BeExactly $false
            } #it
            It 'should return false if the data file is too old' {
                Mock -CommandName Get-Date -MockWith {
                    [datetime]'1/16/20 21:17:22'
                } #endMock
                Confirm-XMLDataSet | Should -BeExactly $false
            } #it
            It 'should return true if the file is found and is less than 9 days old' {
                Confirm-XMLDataSet | Should -BeExactly $true
            } #it
        } #context_Success
    } #describe_Confirm-XMLDataSet
} #inModule
