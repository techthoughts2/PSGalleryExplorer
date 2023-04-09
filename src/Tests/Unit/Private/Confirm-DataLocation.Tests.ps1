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

    Describe 'Confirm-DataLocation' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #before_all

        BeforeEach {
            Mock -CommandName Test-Path -MockWith {
                $true
            } #endMock
            Mock -CommandName New-Item -MockWith { } #endMock
        } #before_each

        Context 'Error' {

            It 'should return false if an error is encountered with Test-Path' {
                Mock -CommandName Test-Path -MockWith {
                    throw 'FakeError'
                } #endMock
                Confirm-DataLocation | Should -BeExactly $false
            } #it

            It 'should return false if an error is encountered with New-Item' {
                Mock -CommandName Test-Path -MockWith {
                    $false
                } #endMock
                Mock -CommandName New-Item -MockWith {
                    throw 'FakeError'
                } #endMock
                Confirm-DataLocation | Should -BeExactly $false
            } #it

        } #context_Error

        Context 'Success' {

            It 'should return true if the output dir already exists' {
                Confirm-DataLocation | Should -BeExactly $true
            } #it

            It 'should return true if the output dir does not exists and is created' {
                Mock -CommandName Test-Path -MockWith {
                    $false
                } #endMock
                Confirm-DataLocation | Should -BeExactly $true
            } #it

        } #context_Success

    } #describe_Confirm-DataLocation

} #inModule
