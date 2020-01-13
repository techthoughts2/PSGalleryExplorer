# This is a locally sourced Imports file for local development.
# It can be imported by the psm1 in local development to add script level variables.
# It will merged in the build process. This is for local development only.

#region scriptvariables

function Get-DataLocation {
    $folderName = "PSGalleryExplorer"
    if ($PROFILE) {
        $script:dataPath = (Join-Path (Split-Path -Parent $PROFILE) $folderName)
    }
    else {
        $script:dataPath = "~\${$folderName}"
    }
}

$script:corps = @(
    'AWS'
    'Amazon'
    'Amazon.com, Inc'
    'AtlassianPS'
    'Bentley Systems, Incorporated'
    'BitTitan'
    'BitTitan, Inc.'
    '(c) 2014 Microsoft Corporation. All rights reserved.'
    'CData Software, Inc.'
    'Chocolatey Software'
    'Cisco Systems'
    'Cisco'
    'DSC Community'
    'Dell Inc.'
    'Dell'
    'DevScope'
    'Docker Inc.'
    'Docker'
    'Google Inc'
    'Google Inc.'
    'Hewlett Packard Enterprise Co.'
    'Hewlett Packard Enterprise'
    'Hewlett-Packard Enterprise'
    'https://github.com/ebekker/ACMESharp'
    'Ironman Software, LLC'
    'JumpCloud'
    'Microsoft (Xbox)'
    'Microsoft Corp'
    'Microsoft Corporation'
    'Microsoft'
    'Mozilla Corporation'
    'Octopus Deploy Pty. Ltd'
    'Octopus Deploy'
    'Pentia A/S'
    'Pentia'
    'PowerShell.org'
    'Pure Storage, Inc.'
    'Red Gate Software Ltd.'
    'SolarWinds Worldwide, LLC.'
    'SolarWinds'
    'SynEdgy Limited'
    'Synergex International Corporation'
    'VMware'
    'VMware, Inc.'
    'waldo.be'
)
$script:regulars = @(
    'BuildHelpers'
    'Carbon'
    'ImportExcel'
    'Invokebuild'
    'PendingReboot'
    'PSDepend'
    'PSDeploy'
    'PSKoans'
    'PSLogging'
    'PSSlack'
    'PSWindowsUpdate'
    'Pester'
    'PoshBot'
    'Selenium'
    'Write-ObjectToSQL'
    'dbatools'
    'oh-my-posh'
    'posh-git'
    'powershell-yaml'
    'psake'
)

$domain = 'amazonaws.com'
$prefix = 'psge-pubxml'
$target = 's3-accelerate'
Get-DataLocation
$script:dataFileZip = 'PSGalleryExplorer.zip'
$script:dataFile = 'PSGalleryExplorer.xml'
$script:dlURI = "$prefix.$target.$domain"
$script:glData = $null

#endregion