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
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
.COMPONENT
    PSGalleryExplorer
#>
function Expand-XMLDataSet {
    [CmdletBinding()]
    param (
    )
    $result = $true #assume the best
    $dataFile = '{0}/{1}' -f $script:dataPath, $script:dataFile

    Write-Verbose -Message 'Testing if data set file alread exists...'
    try {
        $pathEval = Test-Path -Path $dataFile -ErrorAction Stop
        Write-Verbose -Message "EVAL: $true"
    }
    catch {
        $result = $false
        Write-Error $_
        return $result
    }

    if ($pathEval) {
        Write-Verbose -Message 'Removing existing data set file...'
        try {
            $removeItemSplat = @{
                Force       = $true
                Path        = $dataFile
                ErrorAction = 'Stop'
            }
            Remove-Item @removeItemSplat
        } #try
        catch {
            $result = $false
            Write-Error $_
            return $result
        } #catch
    } #if_pathEval

    Write-Verbose -Message 'Expanding data set archive...'
    try {
        $expandArchiveSplat = @{
            DestinationPath = $script:dataPath
            Force           = $true
            ErrorAction     = 'Stop'
            Path            = '{0}/{1}' -f $script:dataPath, $script:dataFileZip
        }
        $null = Expand-Archive @expandArchiveSplat
        Write-Verbose -Message 'Expand completed.'
    } #try
    catch {
        $result = $false
        Write-Error $_
    } #catch

    return $result
} #Expand-XMLDataSet
