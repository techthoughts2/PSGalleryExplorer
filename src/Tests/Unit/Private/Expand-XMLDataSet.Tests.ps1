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

    Describe 'Expand-XMLDataSet' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #before_all

        BeforeEach {
            Mock -CommandName Test-Path -MockWith {
                $false
            } #endMock
            Mock -CommandName Remove-Item -MockWith {

            } #endMock
            Mock -CommandName Expand-Archive -MockWith {
                [PSCustomObject]@{
                    Name         = 'AzModI.xml'
                    Exists       = 'True'
                    CreationTime = [datetime]'01 / 06 / 20 23:02:16'
                }
            } #endMock
        } #before_each

        Context 'Error' {

            It 'should return false if an error is encountered with Test-Path' {
                Mock -CommandName Test-Path -MockWith {
                    throw 'FakeError'
                } #endMock
                Expand-XMLDataSet | Should -BeExactly $false
            } #it

            It 'should return false if an error is encountered with Remove-Item' {
                Mock -CommandName Test-Path -MockWith {
                    $true
                } #endMock
                Mock -CommandName Remove-Item -MockWith {
                    throw 'FakeError'
                } #endMock
                Expand-XMLDataSet | Should -BeExactly $false
            } #it

            It 'should return false if an error is encountered with Expand-Archive' {
                Mock -CommandName Expand-Archive -MockWith {
                    throw 'FakeError'
                } #endMock
                Expand-XMLDataSet | Should -BeExactly $false
            } #it

        } #context_Error

        Context 'Success' {

            It 'should return true if the data file is expanded' {
                Expand-XMLDataSet | Should -BeExactly $true
            } #it

        } #context_Success

    } #describe_Expand-XMLDataSet

} #inModule
