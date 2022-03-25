<#
.SYNOPSIS
    Confirm data output location. Creates output dir if not present.
.DESCRIPTION
    Evaluates presence of data output location for xml dataset. If the directory is not found, it will be created.
.EXAMPLE
    Confirm-DataLocation

    Confirms presence of data output location. Creates if not found.
.OUTPUTS
    System.Boolean
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
.COMPONENT
    PSGalleryExplorer
#>
function Confirm-DataLocation {
    [CmdletBinding()]
    param (
    )
    $result = $true #assume the best
    Write-Verbose -Message 'Verifying data set output location...'
    try {
        $pathEval = Test-Path -Path $script:dataPath -ErrorAction Stop
    }
    catch {
        $result = $false
        Write-Error $_
        return $result
    }

    if (-not ($pathEval)) {
        Write-Verbose -Message 'Creating output directory...'
        try {
            $newItemSplat = @{
                ItemType    = 'Directory'
                Path        = $script:dataPath
                ErrorAction = 'Stop'
            }
            $null = New-Item @newItemSplat
            Write-Verbose -Message 'Created.'
        }
        catch {
            $result = $false
            Write-Error $_
            return $result
        }
    } #if_TestPath
    else {
        Write-Verbose 'Data path confirmed.'
    } #else_TestPath

    return $result
} #Confirm-DataLocation
