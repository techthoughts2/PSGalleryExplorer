<#
.SYNOPSIS
    Unzips the XML data set.
.DESCRIPTION
    Evalutes for previous version of XML data set and removes if required. Expands the XML data set for use.
.EXAMPLE
    Expand-XMLDataSet

    Unzips and expands the XML data set.
.OUTPUTS
    System.Boolean
.NOTES
    None
.COMPONENT
    PSGalleryExplorer
#>
function Expand-XMLDataSet {
    [CmdletBinding()]
    param (
    )
    $result = $true #assume the best
    Write-Verbose -Message 'Testing if data set file alread exists...'
    try {
        $pathEval = Test-Path -Path "$script:dataPath\$script:dataFile" -ErrorAction Stop
        Write-Verbose -Message "EVAL: $true"
    }#try
    catch {
        $result = $false
        Write-Error $_
        return $result
    }#catch

    if ($pathEval) {
        Write-Verbose -Message 'Removing existing data set file...'
        try {
            $removeItemSplat = @{
                Force       = $true
                Path        = "$script:dataPath\$script:dataFile"
                ErrorAction = 'Stop'
            }
            Remove-Item @removeItemSplat
        }#try
        catch {
            $result = $false
            Write-Error $_
            return $result
        }#catch
    }#if_pathEval

    Write-Verbose -Message 'Expanding data set archive...'
    try {
        $expandArchiveSplat = @{
            DestinationPath = "$script:dataPath"
            Force           = $true
            ErrorAction     = 'Stop'
            Path            = "$script:dataPath\$script:dataFileZip"
        }
        $null = Expand-Archive @expandArchiveSplat
        Write-Verbose -Message 'Expand completed.'
    }#try
    catch {
        $result = $false
        Write-Error $_
    }#catch

    return $result
}#Expand-XMLDataSet