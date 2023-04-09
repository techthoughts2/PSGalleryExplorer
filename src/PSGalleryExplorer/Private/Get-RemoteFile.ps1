<#
.SYNOPSIS
    Downloads file to device.
.DESCRIPTION
    Retrieves file from web and downloads to device.
.EXAMPLE
    Get-RemoteFile

    Downloads file to data path.
.PARAMETER File
    File to download.
.PARAMETER OutFileName
    Specify output file name.
.OUTPUTS
    System.Boolean
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
    Overwrites existing zip file.
.COMPONENT
    PSGalleryExplorer
#>
function Get-RemoteFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'File to download')]
        [string]$File,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Specify output file name.')]
        [string]$OutFileName
    )
    $result = $true #assume the best

    if ($OutFileName) {
        $OutFile = $OutFileName
    }
    else {
        $OutFile = $File
    }

    Write-Verbose -Message 'Downloading file...'
    try {
        $invokeWebRequestSplat = @{
            OutFile     = [System.IO.Path]::Combine($script:dataPath, $OutFile)
            Uri         = 'https://{0}/{1}' -f $script:dlURI, $File
            ErrorAction = 'Stop'
        }
        $oldProgressPreference = $progressPreference
        $progressPreference = 'SilentlyContinue'
        if ($PSEdition -eq 'Desktop') {
            $null = Invoke-WebRequest @invokeWebRequestSplat -PassThru -UseBasicParsing
        }
        else {
            $null = Invoke-WebRequest @invokeWebRequestSplat -PassThru
        }
    } #try
    catch {
        $result = $false
        Write-Error $_
    } #catch
    finally {
        $progressPreference = $oldProgressPreference
    } #finally
    return $result
} #Get-RemoteFile
