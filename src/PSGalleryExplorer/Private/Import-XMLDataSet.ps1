<#
.SYNOPSIS
    Evaluates if XML data set is in memory and kicks of child processes to obtain XML data set.
.DESCRIPTION
    XML data set will be evaluated if already in memory. If not, a series of processes will be kicked off to load the XML data set for use.
.EXAMPLE
    Import-XMLDataSet

    Loads the XML data set into memory.
.OUTPUTS
    System.Boolean
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
    Parent process for getting XML data.
.COMPONENT
    PSGalleryExplorer
#>
function Import-XMLDataSet {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseCorrectCasing', '', Justification = 'ConvertFrom-Clixml is used in more than one module with different casing requirements.')]
    [CmdletBinding()]
    param (
    )
    $result = $true #assume the best
    Write-Verbose -Message 'Verifying current state of XML data set...'
    if ($null -eq $script:glData) {
        $dataCheck = Invoke-XMLDataCheck
        if ($dataCheck) {
            try {
                $getContentSplat = @{
                    Path        = "$script:dataPath\$script:dataFile"
                    Raw         = $true
                    ErrorAction = 'Stop'
                }
                $fileData = Get-Content @getContentSplat
                $script:glData = $fileData | ConvertFrom-Clixml -ErrorAction Stop
            } #try
            catch {
                $result = $false
                Write-Error $_
            } #catch
        } #if_dataCheck
        else {
            $result = $false
        } #else_dataCheck
    } #if_gldata
    return $result
} #Import-XMLDataSet
