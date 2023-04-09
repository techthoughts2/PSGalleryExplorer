<#
.SYNOPSIS
    Compares the local metadata file to the remote metadata file.
.DESCRIPTION
    Evaluates the local metadata file and compares it to the remote metadata file. If the files are the same, returns true. If the files are different, returns false.
.EXAMPLE
    Confirm-MetadataUpdate

    Compares the local metadata file to the remote metadata file.
.OUTPUTS
    System.Boolean
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
.COMPONENT
    PSGalleryExplorer
#>
function Confirm-MetadataUpdate {
    [CmdletBinding()]
    param (
    )
    $result = $true #assume the best

    Write-Verbose -Message 'Checking for metadata file...'
    $localMetaDataFilePath = [System.IO.Path]::Combine($script:dataPath, $script:metadataFile)
    try {
        $pathEval = Test-Path -Path $localMetaDataFilePath -ErrorAction Stop
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
        Write-Verbose 'Metadata file found. Performing metadata comparison...'
        try {
            $localMetadata = Get-Content $localMetaDataFilePath -ErrorAction 'Stop' | ConvertFrom-Json
        }
        catch {
            $result = $false
            Write-Error $_
            return $result
        }

        $tempMetadataFile = '{0}_temp' -f $script:metadataFile
        $tempMetadataFilePath = [System.IO.Path]::Combine($script:dataPath, $tempMetadataFile)
        # if the temp metadata file exists, delete it
        if (Test-Path -Path $tempMetadataFile) {
            Remove-Item -Path $tempMetadataFilePath -Force
        }

        # download metadata file for comparison
        $fileFetchStatus = Get-RemoteFile -File $script:metadataFile -OutFile $tempMetadataFile
        if ($fileFetchStatus -eq $false) {
            Write-Error 'Unable to download metadata file.'
            $result = $false
            return $result
        }

        try {
            $remoteMetadata = Get-Content $tempMetadataFilePath -ErrorAction 'Stop' | ConvertFrom-Json
        }
        catch {
            $result = $false
            Write-Error $_
            return $result
        }

        Write-Verbose -Message ('{0} vs {1}' -f $localMetadata.zipCreated, $remoteMetadata.zipCreated)
        if ($localMetadata.zipCreated -eq $remoteMetadata.zipCreated) {
            Write-Verbose 'Metadata file is current.'
        }
        else {
            Write-Verbose 'Metadata file requires refresh.'
            $result = $false
        }
    }

    return $result
} #Confirm-MetadataUpdate
