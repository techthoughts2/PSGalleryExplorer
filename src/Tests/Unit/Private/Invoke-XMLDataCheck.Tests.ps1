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

    Describe 'Invoke-XMLDataCheck' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            function Confirm-DataLocation {
            }
            function Confirm-XMLDataSet {
            }
            function Expand-XMLDataSet {
            }
            function Get-RemoteFile {
            }
            function Remove-Item {
            }
        } #before_all

        Context 'ShouldProcess' {
            BeforeEach {
                Mock -CommandName Invoke-XMLDataCheck -MockWith { } #endMock
            } #before_each
            It 'Should process by default' {
                Invoke-XMLDataCheck
                Assert-MockCalled Invoke-XMLDataCheck -Scope It -Exactly -Times 1
            } #it
            It 'Should not process on explicit request for confirmation (-Confirm)' {
                { Invoke-XMLDataCheck -Confirm }
                Assert-MockCalled Invoke-XMLDataCheck -Scope It -Exactly -Times 0
            } #it
            It 'Should not process on implicit request for confirmation (ConfirmPreference)' {
                {
                    $ConfirmPreference = 'Low'
                    Invoke-XMLDataCheck
                }
                Assert-MockCalled Invoke-XMLDataCheck -Scope It -Exactly -Times 0
            } #it
            It 'Should not process on explicit request for validation (-WhatIf)' {
                { Invoke-XMLDataCheck -WhatIf }
                Assert-MockCalled Invoke-XMLDataCheck -Scope It -Exactly -Times 0
            } #it
            It 'Should not process on implicit request for validation (WhatIfPreference)' {
                {
                    $WhatIfPreference = $true
                    Invoke-XMLDataCheck
                }
                Assert-MockCalled Invoke-XMLDataCheck -Scope It -Exactly -Times 0
            } #it
            It 'Should process on force' {
                $ConfirmPreference = 'Medium'
                Invoke-XMLDataCheck -Force
                Assert-MockCalled Invoke-XMLDataCheck -Scope It -Exactly -Times 1
            } #it
        } #context_shouldprocess

        BeforeEach {
            Mock -CommandName Confirm-DataLocation -MockWith {
                $true
            } #endMock
            Mock -CommandName Confirm-XMLDataSet -MockWith {
                $true
            } #endMock
            Mock -CommandName Expand-XMLDataSet -MockWith {
                $true
            } #endMock
            Mock -CommandName Get-RemoteFile -MockWith {
                $true
            } #endMock
            Mock -CommandName Test-Path -MockWith {
                $true
            } #endMock
            Mock -CommandName Remove-Item -MockWith {}
        } #before_each

        Context 'Success' {

            It 'should return true if the data file is confirmed' {
                Invoke-XMLDataCheck -Force | Should -BeExactly $true
            } #it

            It 'should return false if the data output dir cannot be confirmed' {
                Mock -CommandName Confirm-DataLocation -MockWith {
                    $false
                } #endMock
                Invoke-XMLDataCheck -Force | Should -BeExactly $false
            } #it

            It 'should return false if the data file is not confirmed and the file can not be downloaded' {
                Mock -CommandName Confirm-XMLDataSet -MockWith {
                    $false
                } #endMock
                Mock -CommandName Get-RemoteFile -MockWith {
                    $false
                } #endMock
                Invoke-XMLDataCheck -Force | Should -BeExactly $false
            } #it

            It 'should return false if the data file is not confirmed and the file is downloaded, but can not be expanded' {
                Mock -CommandName Confirm-XMLDataSet -MockWith {
                    $false
                } #endMock
                Mock -CommandName Expand-XMLDataSet -MockWith {
                    $false
                } #endMock
                Invoke-XMLDataCheck -Force | Should -BeExactly $false
            } #it

            It 'should return true if the data file is not confirmed and the file is downloaded and expanded' {
                Mock -CommandName Confirm-XMLDataSet -MockWith {
                    $false
                } #endMock
                Invoke-XMLDataCheck -Force | Should -BeExactly $true
            } #it

            It 'should download 2 files if the data file is not confirmed' {
                Mock -CommandName Confirm-XMLDataSet -MockWith {
                    $false
                } #endMock
                Invoke-XMLDataCheck -Force
                Should -Invoke Get-RemoteFile -Scope It -Exactly -Times 2
            } #it

            It 'should not attempt to remove the metadata file if it does not exist' {
                Mock -CommandName Confirm-XMLDataSet -MockWith {
                    $false
                } #endMock
                Mock -CommandName Test-Path -MockWith {
                    $false
                } #endMock
                Invoke-XMLDataCheck -Force
                Should -Invoke Remove-Item -Scope It -Exactly -Times 0
            } #it

        } #context_Success

    } #describe_Invoke-XMLDataCheck

} #inModule
