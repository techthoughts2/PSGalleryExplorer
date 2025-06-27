<#
.SYNOPSIS
    Invokes all child functions required to process retrieving the XML data set file.
.DESCRIPTION
    Runs all required child functions to successfully retrieve and process the XML data set file.
.EXAMPLE
    Invoke-XMLDataCheck

    Downloads, expands, and verified the XML data set file.
.OUTPUTS
    System.Boolean
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
    Confirm-XMLDataSet
    Get-RemoteFile
    Expand-XMLDataSet
.COMPONENT
    PSGalleryExplorer
#>
function Invoke-XMLDataCheck {
    [CmdletBinding(ConfirmImpact = 'Low',
        SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $false,
            HelpMessage = 'Skip confirmation')]
        [switch]$Force
    )
    begin {

        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.SessionState.PSVariable.GetValue('VerbosePreference')
        }
        if (-not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
        }
        if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
            $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
        }

        Write-Verbose -Message ('[{0}] Confirm={1} ConfirmPreference={2} WhatIf={3} WhatIfPreference={4}' -f $MyInvocation.MyCommand, $Confirm, $ConfirmPreference, $WhatIf, $WhatIfPreference)

        $results = $true #assume the best
    } #begin
    process {
        # -Confirm --> $ConfirmPreference = 'Low'
        # ShouldProcess intercepts WhatIf* --> no need to pass it on
        if ($Force -or $PSCmdlet.ShouldProcess("ShouldProcess?")) {
            Write-Verbose -Message ('[{0}] Reached command' -f $MyInvocation.MyCommand)
            $ConfirmPreference = 'None'

            $dataOutputDir = Confirm-DataLocation
            if ($dataOutputDir -eq $true) {
                $confirm = Confirm-XMLDataSet
                if (-not $confirm -eq $true) {
                    $retrieve = Get-RemoteFile -File $script:dataFileZip
                    # remove metadata file if it exists
                    $localMetaDataFilePath = [System.IO.Path]::Combine($script:dataPath, $script:metadataFile)
                    if (Test-Path -Path $localMetaDataFilePath) {
                        Remove-Item -Path $localMetaDataFilePath -Force
                    }
                    $retrieveMetadata = Get-RemoteFile -File $script:metadataFile
                    if ($retrieve -eq $true -and $retrieveMetadata -eq $true) {
                        $expand = Expand-XMLDataSet
                        if (-not $expand -eq $true) {
                            $results = $false
                        }
                    }
                    else {
                        $results = $false
                    }
                } #if_Confirm
            } #if_data_output
            else {
                $results = $false
            } #else_data_output

        } #if_Should
    } #process
    end {
        return $results
    } #end
} #Invoke-XMLDataCheck
