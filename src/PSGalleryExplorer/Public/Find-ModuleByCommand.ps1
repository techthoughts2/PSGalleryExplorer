<#
.SYNOPSIS
    Searches for modules that contain a specific command or cmdlet name.
.DESCRIPTION
    The Find-ModuleByCommand cmdlet searches for modules on the PowerShell Gallery that contain a specified command or cmdlet name. The cmdlet returns a list of modules that include the command or cmdlet, along with key metrics and information about the module. This cmdlet is useful when you need to quickly find a module that includes a particular command or cmdlet, without having to install or download the module first.
.EXAMPLE
    Find-ModuleByCommand -CommandName New-ModuleProject

    Returns a list of modules that contain the command New-ModuleProject
.EXAMPLE
    Find-ModuleByCommand -CommandName 'Send-TelegramTextMessage'

    Returns a list of modules that contain the command Send-TelegramTextMessage
.PARAMETER CommandName
    Specifies the command name to search for
.OUTPUTS
    PSGEFormat
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
.COMPONENT
    PSGalleryExplorer
#>
function Find-ModuleByCommand {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Specifies the command name to search for')]
        [string]$CommandName
    )
    Write-Verbose -Message 'Verifying XML Data Set Availability...'
    if (Import-XMLDataSet) {
        Write-Verbose -Message 'Verified.'
        $dataSet = $script:glData

        Write-Verbose -Message ('Searching for Modules that contain the command: {0}' -f $CommandName)
        $find = $dataSet | Where-Object {
            $_.Includes.Function -contains $CommandName -or
            $_.Includes.Command -contains $CommandName -or
            $_.Includes.Cmdlet -contains $CommandName
        }

    } #if_Import-XMLDataSet
    else {
        Write-Warning -Message 'PSGalleryExplorer was unable to source the required data set file.'
        Write-Warning -Message 'Ensure you have an active internet connection'
        return
    } #else_Import-XMLDataSet

    Write-Verbose -Message 'Adding output properties to objects...'
    foreach ($item in $find) {
        $metrics = $null
        $metrics = @{
            Downloads  = $item.AdditionalMetadata.downloadCount
            LastUpdate = $item.AdditionalMetadata.lastUpdated
            Star       = $item.ProjectInfo.StarCount
            Sub        = $item.ProjectInfo.Subscribers
            Watch      = $item.ProjectInfo.Watchers
            Fork       = $item.ProjectInfo.Forks
            Issues     = $item.ProjectInfo.Issues
            RepoUpdate = $item.ProjectInfo.Updated
        }
        $item | Add-Member -NotePropertyMembers $metrics -TypeName Asset -Force
        $item.PSObject.TypeNames.Insert(0, 'PSGEFormat')
    } #foreach_find
    Write-Verbose -Message 'Properties addition completed.'

    return $find
} #Find-ModuleByCommand
