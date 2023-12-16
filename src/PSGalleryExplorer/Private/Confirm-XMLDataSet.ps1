<#
.SYNOPSIS
    Confirms the XML dataset file is available and not beyond the expiration time.
.DESCRIPTION
    Determines if the XML dataset file is stale or not available.
    If the file is not available, false will be returned so it can be downloaded.
    If the file is available, but over 9 days old, the metadata file will be checked to see if an update is available.
    If an update is available after the metadata file is checked, false will be returned so the data file can be refreshed.
.EXAMPLE
    Confirm-XMLDataSet

    Checks for XML dataset and determines if it is 9 days older or more.
.OUTPUTS
    System.Boolean
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
.COMPONENT
    PSGalleryExplorer
#>
function Confirm-XMLDataSet {
    [CmdletBinding()]
    param (
    )
    $result = $true #assume the best
    $dataFile = '{0}/{1}' -f $script:dataPath, $script:dataFile

    Write-Verbose -Message 'Confirming valid and current data set...'

    # if the file doesn't exist, we need to download it
    Write-Verbose -Message 'Checking for data file...'
    try {
        $pathEval = Test-Path -Path $dataFile -ErrorAction Stop
    }
    catch {
        $result = $false
        Write-Error $_
        return $result
    }

    if (-not ($pathEval)) {
        $result = $false
    } #if_pathEval
    else {
        Write-Verbose 'Data file found. Checking date of file...'
        try {
            $fileData = Get-Item -Path $dataFile -ErrorAction Stop
        }
        catch {
            $result = $false
            Write-Error $_
            return $result
        }
        if ($fileData) {
            $creationDate = $fileData.LastWriteTime
            $now = Get-Date
            if (($now - $creationDate).Days -ge 9) {
                # Write-Verbose 'Data file requires refresh.'
                Write-Verbose 'Data file is older than 9 days. Checking if an update is available...'
                $metadataStatus = Confirm-MetadataUpdate
                if ($metadataStatus -eq $false) {
                    Write-Verbose 'Refreshing data file...'
                    $result = $false
                }
                else {
                    Write-Verbose 'No update available. Data file is current.'
                }
            }
            else {
                Write-Verbose 'Data file verified'
            }
        } #if_fileData
        else {
            Write-Warning 'Unable to retrieve file information for PSGalleryExplorer data set.'
            $result = $false
            return $result
        } #else_fileData
    } #else_pathEval

    return $result
} #Confirm-XMLDataSet
