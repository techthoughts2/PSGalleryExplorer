<#
.SYNOPSIS
    Finds PowerShell Gallery module(s) that match specified criteria.
.DESCRIPTION
    Searches PowerShell Gallery for modules and their associated project repositories. Results are returned based on provided criteria. By default, more common/popular modules and modules made by corporations are excluded. This is to aid in discovery of other modules. Popular modules and corporation modules can be included in results by specifying the necessary parameter switches. 35 module results are returned by default unless the NumberToReturn parameter is used.
.EXAMPLE
    Find-PSGModule -ByDownloads

    Returns up to 35 modules based on number of PowerShell Gallery downloads.
.EXAMPLE
    Find-PSGModule -ByDownloads -IncludeRegulars

    Returns up to 35 modules based on number of PowerShell Gallery downloads including more popular modules.
.EXAMPLE
    Find-PSGModule -ByDownloads -IncludeCorps -IncludeRegulars -NumberToReturn 50

    Returns up to 50 modules based on number of PowerShell Gallery downloads including more popular downloads, and modules made by corporations.
.EXAMPLE
    Find-PSGModule -ByRepoInfo StarCount

    Returns up to 35 modules based on number of stars the project's repository has.
.EXAMPLE
    Find-PSGModule -ByRepoInfo Forks

    Returns up to 35 modules based on number of forks the project's repository has.
.EXAMPLE
    Find-PSGModule -ByRepoInfo Issues

    Returns up to 35 modules based on number of issues the project's repository has.
.EXAMPLE
    Find-PSGModule -ByRepoInfo Subscribers

    Returns up to 35 modules based on number of subscribers the project's repository has.
.EXAMPLE
    Find-PSGModule -ByRecentUpdate GalleryUpdate

    Returns up to 35 modules based on their most recent PowerShell Gallery update.
.EXAMPLE
    Find-PSGModule -ByRecentUpdate RepoUpdate

    Returns up to 35 modules based on recent updates to their associated repository.
.EXAMPLE
    Find-PSGModule -ByRandom

    Returns up to 35 modules randomly
.EXAMPLE
    Find-PSGModule -ByName 'PoshGram'

    Returns module that equals the provided name, if found.
.EXAMPLE
    Find-PSGModule -ByName 'Posh*'

    Returns all modules that match the wild card provided name, if found.
.EXAMPLE
    Find-PSGModule -ByTag Telegram

    Returns up to 35 modules that contain the tag: Telegram.
.EXAMPLE
    Find-PSGModule -ByTag Telegram -IncludeCorps -IncludeRegulars -NumberToReturn 100

    Returns up to 100 modules that contains the tag: Telegram, including more popular modules and modules made by corporations.
.EXAMPLE
    $results = Find-PSGModule -ByRepoInfo Watchers -IncludeCorps -IncludeRegulars -NumberToReturn 40
    $results | Format-List

    Returns up to 40 modules based on number of module project repository watchers. It includes more popular modules as well as modules made by corporations. A list of results is displayed.
.EXAMPLE
    Find-PSGModule

    Returns all non-corp/non-regular modules
.EXAMPLE
    Find-PSGModule -IncludeCorps -IncludeRegulars

    Returns all modules
.PARAMETER ByDownloads
    Find modules by number of PowerShell Gallery Downloads
.PARAMETER ByRepoInfo
    Find modules based on various project repository metrics
.PARAMETER ByRecentUpdate
    Find modules based on recent updated to PowerShell Gallery or associated repository
.PARAMETER ByRandom
    Find modules randomly from the PowerShell Gallery
.PARAMETER ByName
    Find module by module name
.PARAMETER ByTag
    Find modules by tag
.PARAMETER IncludeCorps
    Include modules written by corporations in results
.PARAMETER IncludeRegulars
    Include modules that are well known in results
.PARAMETER NumberToReturn
    Max number of modules to return
.OUTPUTS
    PSGEFormat
.NOTES
    Author: Jake Morrison - @jakemorrison - https://techthoughts.info/
.COMPONENT
    PSGalleryExplorer
#>
function Find-PSGModule {
    [CmdletBinding(defaultparametersetname = 'none')]
    param (
        [Parameter(ParameterSetName = 'GalleryDownloads',
            HelpMessage = 'Find by PowerShell Gallery Downloads')]
        [switch]
        $ByDownloads,
        [Parameter(ParameterSetName = 'Repo',
            HelpMessage = 'Find by Repository metrics')]
        [ValidateSet(
            'StarCount',
            'Forks',
            'Issues',
            'Subscribers'
        )]
        [string]
        $ByRepoInfo,
        [Parameter(ParameterSetName = 'Update',
            HelpMessage = 'Find by recently updated')]
        [string]
        [ValidateSet(
            'GalleryUpdate',
            'RepoUpdate'
        )]
        $ByRecentUpdate,
        [Parameter(ParameterSetName = 'GalleryDownloads',
            HelpMessage = 'Find random PowerShell Gallery modules')]
        [switch]
        $ByRandom,
        [Parameter(ParameterSetName = 'Names',
            HelpMessage = 'Find by name')]
        [string]
        $ByName,
        [Parameter(ParameterSetName = 'Tags',
            HelpMessage = 'Find by tag')]
        [string]
        [ValidatePattern('^[A-Za-z]+')]
        $ByTag,
        [Parameter(HelpMessage = 'Include corporation results')]
        [switch]
        $IncludeCorps,
        [Parameter(HelpMessage = 'Include more popular results')]
        [switch]
        $IncludeRegulars,
        [Parameter(Mandatory = $false,
            HelpMessage = 'Max number of modules to return')]
        [int]
        $NumberToReturn = 35
    )
    Write-Verbose -Message 'Verifying XML Data Set Availability...'
    if (Import-XMLDataSet) {
        Write-Verbose -Message 'Verified.'

        #__________________________________________________________
        Write-Verbose -Message 'Processing exclusions...'
        if ($IncludeCorps -and $IncludeRegulars) {
            $dataSet = $script:glData
        }
        elseif ($ByName) {
            $dataSet = $script:glData
        }
        elseif ($IncludeCorps) {
            $dataSet = $script:glData | Where-Object {
                $_.Name -notin $script:regulars
            }
        }
        elseif ($IncludeRegulars) {
            $dataSet = $script:glData | Where-Object {
                $_.AdditionalMetadata.CompanyName -notin $script:corps -and
                $_.Author -notin $script:corps -and
                $_.AdditionalMetadata.copyright -notin $script:corps
            }
        }
        else {
            $dataSet = $script:glData | Where-Object {
                $_.AdditionalMetadata.CompanyName -notin $script:corps -and
                $_.Author -notin $script:corps -and
                $_.AdditionalMetadata.copyright -notin $script:corps -and
                $_.Name -notin $script:regulars
            }
        }
        Write-Verbose -Message 'Exclusions completed.'
        #__________________________________________________________
        if ($ByRepoInfo) {
            Write-Verbose -Message 'ByRepoInfo'
            $gitModules = $dataSet | Where-Object { $_.GitHubInfo.GitStatus -eq $true }
            $find = $gitModules | Sort-Object -Property { [int]$_.GitHubInfo.$ByRepoInfo } -Descending | Select-Object -First $NumberToReturn
        }#if_ByRepoInfo
        elseif ($ByDownloads) {
            Write-Verbose -Message 'ByDownloads'
            $find = $dataSet | Sort-Object -Property { [int]$_.AdditionalMetadata.downloadCount } -Descending | Select-Object -First $NumberToReturn
        }#elseif_ByDownloads
        elseif ($ByRecentUpdate) {
            Write-Verbose -Message 'ByRecentUpdate'
            switch ($ByRecentUpdate) {
                'GalleryUpdate' {
                    $find = $dataSet | Sort-Object -Property { [datetime]$_.AdditionalMetadata.updated } -Descending | Select-Object -First $NumberToReturn
                }
                'RepoUpdate' {
                    $gitModules = $dataSet | Where-Object { $_.GitHubInfo.GitStatus -eq $true }
                    $find = $gitModules | Sort-Object -Property { [datetime]$_.GitHubInfo.Updated } -Descending | Select-Object -First $NumberToReturn
                }
            }
        }#elseif_ByRecentUpdate
        elseif ($ByRandom) {
            Write-Verbose -Message 'ByRandom'
            $captured = @()
            $randoms = @()
            for ($i = 0; $i -lt $NumberToReturn; $i++) {
                $thisRound = $null
                $thisRound = $dataSet | Where-Object { $captured -notcontains $_.Name } | Get-Random
                $captured += $thisRound.Name
                $randoms += $thisRound
            }
            $find = $randoms | Sort-Object -Property { [int]$_.AdditionalMetadata.downloadCount } -Descending
        }#elseif_ByRandom
        elseif ($ByName) {
            Write-Verbose -Message 'ByName'
            if ($ByName -like '*`**') {
                $find = $dataSet | Where-Object { $_.Name -like $ByName }
            }
            else {
                $find = $dataSet | Where-Object { $_.Name -eq $ByName }
            }
        }#ByName
        elseif ($ByTag) {
            Write-Verbose -Message 'ByTag'
            $tagModules = $dataSet | Where-Object { $ByTag -in $_.Tags }
            $find = $tagModules | Sort-Object -Property { [int]$_.AdditionalMetadata.downloadCount } -Descending | Select-Object -First $NumberToReturn
        }#ByTag
        else {
            $find = $dataSet | Sort-Object -Property { [int]$_.AdditionalMetadata.downloadCount } -Descending
        }#everything
        #__________________________________________________________
    }#if_Import-XMLDataSet
    else {
        Write-Warning -Message 'PSGalleryExplorer was unable to source the required data set file.'
        Write-Warning -Message 'Ensure you have an active internet connection'
        return
    }#else_Import-XMLDataSet

    Write-Verbose -Message 'Adding output properties to objects...'
    foreach ($item in $find) {
        $metrics = $null
        $metrics = @{
            Downloads  = $item.AdditionalMetadata.downloadCount
            LastUpdate = $item.AdditionalMetadata.lastUpdated
            Star       = $item.GitHubInfo.StarCount
            Sub        = $item.GitHubInfo.Subscribers
            Watch      = $item.GitHubInfo.Watchers
            Fork       = $item.GitHubInfo.Forks
            Issues     = $item.GitHubInfo.Issues
            RepoUpdate = $item.GitHubInfo.Updated
        }
        $item | Add-Member -NotePropertyMembers $metrics -TypeName Asset -Force
        $item.PSObject.TypeNames.Insert(0, 'PSGEFormat')
    }#foreach_find
    Write-Verbose -Message 'Properties addition completed.'

    return $find
}#Find-PSGModule