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

    Describe 'Get-RemoteFile' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            $fileName = 'test.zip'
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

            It 'should return false if an error is encountered downloading the file' {
                Mock -CommandName Invoke-WebRequest -MockWith {
                    throw 'FakeError'
                } #endMock
                Get-RemoteFile -File $fileName | Should -BeExactly $false
            } #it

        } #context_FunctionName

        Context 'Success' {

            It 'should return true if the file is downloaded' {
                Get-RemoteFile  -File $fileName | Should -BeExactly $true
            } #it

            It 'should call Invoke-WebRequest with the correct parameters' {
                $outPath = [System.IO.Path]::Combine($script:dataPath, $fileName)
                Get-RemoteFile -File $fileName
                Assert-MockCalled -CommandName Invoke-WebRequest -Times 1 -Exactly -Scope It -ParameterFilter {
                    $OutFile -eq $outPath -and $Uri -eq "https://$script:dlURI/$fileName"
                }
            } #it

            It 'should call Invoke-WebRequest with the correct parameters if OutFileName is specified' {
                $fileNameOverride = 'test2.zip'
                $outPath = [System.IO.Path]::Combine($script:dataPath, $fileNameOverride)
                Get-RemoteFile -File $fileName -OutFileName $fileNameOverride
                Assert-MockCalled -CommandName Invoke-WebRequest -Times 1 -Exactly -Scope It -ParameterFilter {
                    $OutFile -eq $outPath -and $Uri -eq "https://$script:dlURI/$fileName"
                }
            } #it

        } #context_Success

    } #describe_Get-RemoteFile

} #inModule
