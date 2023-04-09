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
    Describe 'Confirm-MetadataUpdate' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            $metadataJSON = @'
{
    "zipCreated": "1679500816"
}
'@
            $metadataJSON2 = @'
{
    "zipCreated": "1679500817"
}
'@
            function Remove-Item {
            }
        } #before_all

        BeforeEach {
            Mock -CommandName Test-Path -MockWith {
                $true
            } #endMock
            Mock -CommandName Get-Content -MockWith {
                $metadataJSON
            } #endMock
            Mock -CommandName Remove-Item -MockWith {}
            Mock -CommandName Get-RemoteFile -MockWith {
                $true
            } #endMock
        } #before_each

        Context 'Error' {

            It 'should return false if an error is encountered with Test-Path' {
                Mock -CommandName Test-Path -MockWith {
                    throw 'FakeError'
                } #endMock
                Confirm-MetadataUpdate | Should -BeExactly $false
            } #it

            It 'should return false if an error is encountered with Get-Content' {
                Mock -CommandName Get-Content -MockWith {
                    throw 'FakeError'
                } #endMock
                Confirm-MetadataUpdate | Should -BeExactly $false
            } #it

            It 'should return false if the metadata file is not downloaded' {
                Mock -CommandName Get-RemoteFile -MockWith {
                    $false
                } #endMock
                Confirm-MetadataUpdate | Should -BeExactly $false
            } #it

            It 'should return false if an error is encountered with second Get-Content' {
                $script:mockCalled = 0
                $mockInvoke = {
                    $script:mockCalled++
                    if ($script:mockCalled -eq 1) {
                        return $metadataJSON
                    }
                    elseif ($script:mockCalled -eq 2) {
                        throw 'FakeError'
                    }
                }
                Mock -CommandName Get-Content -MockWith $mockInvoke
                Confirm-MetadataUpdate | Should -BeExactly $false
            } #it

        } #context_Error

        Context 'Success' {

            It 'should return false if the metadata file is not found' {
                Mock -CommandName Test-Path -MockWith {
                    $false
                } #endMock
                Confirm-MetadataUpdate | Should -BeExactly $false
            } #it

            It 'should return true if the local and remote metadata files are the same' {
                Confirm-MetadataUpdate | Should -BeExactly $true
            } #it

            It 'should return false if the local and remote metadata files are different' {
                $script:mockCalled = 0
                $mockInvoke = {
                    $script:mockCalled++
                    if ($script:mockCalled -eq 1) {
                        return $metadataJSON
                    }
                    elseif ($script:mockCalled -eq 2) {
                        return $metadataJSON2
                    }
                }
                Mock -CommandName Get-Content -MockWith $mockInvoke
                Confirm-MetadataUpdate | Should -BeExactly $false
            } #it

        } #context_Success

    } #describe_Confirm-MetadataUpdate

} #inModule
