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
    Describe 'Get-XMLDataSet' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #before_all
        BeforeEach {
            Mock -CommandName Invoke-WebRequest -MockWith {
                [PSCustomObject]@{
                    StatusCode        = '200'
                    StatusDescription = 'OK'
                    Content           = '{80, 75, 3, 4}'
                }
            } #endMock
        } #before_each
        Context 'Error' {
            It 'should return false if an error is encountered downloading the data file' {
                Mock -CommandName Invoke-WebRequest -MockWith {
                    throw 'FakeError'
                } #endMock
                Get-XMLDataSet | Should -BeExactly $false
            } #it
        } #context_FunctionName
        Context 'Success' {
            It 'should return true if the data file is downloaded' {
                Get-XMLDataSet | Should -BeExactly $true
            } #it
        } #context_Success
    } #describe_Get-XMLDataSet
} #inModule
