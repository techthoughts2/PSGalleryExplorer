<#
.SYNOPSIS
    Downloads XML Data set to device.
.DESCRIPTION
    Retrieves XML Data zip file from web and downloads to device.
.EXAMPLE
    Get-XMLDataSet

    Downloads XML data set to data path.
.OUTPUTS
    System.Boolean
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
    Overwrites existing zip file.
.COMPONENT
    PSGalleryExplorer
#>
function Get-XMLDataSet {
    [CmdletBinding()]
    param (
    )
    $result = $true #assume the best

    Write-Verbose -Message 'Downloading XML data set...'
    try {
        $invokeWebRequestSplat = @{
            OutFile     = '{0}/{1}' -f $script:dataPath, $script:dataFileZip
            Uri         = 'https://{0}/{1}' -f $script:dlURI, $script:dataFileZip
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
} #Get-XMLDataSet
