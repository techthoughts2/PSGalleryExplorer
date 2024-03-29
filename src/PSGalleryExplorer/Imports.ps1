# This is a locally sourced Imports file for local development.
# It can be imported by the psm1 in local development to add script level variables.
# It will merged in the build process. This is for local development only.

#region script variables

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
    '2AT B.V.'
    '3Shape A/S'
    'AWS'
    'Amazon'
    'Amazon.com, Inc'
    'Amazon Web Services'
    'AtlassianPS'
    'BAMCIS'
    'Bentley Systems, Incorporated'
    'BitTitan'
    'BitTitan, Inc.'
    '(c) 2014 Microsoft Corporation. All rights reserved.'
    'CData Software, Inc.'
    'Chocolatey Software'
    'Cisco Systems'
    'Cisco'
    'Cisco Systems, Inc.'
    'Cybersecurity Engineering'
    'DSC Community'
    'Dell Inc.'
    'Dell Technologies'
    'Dell'
    'DELL|EMC'
    'DELL||EMC'
    'Dell EMC'
    'DevScope'
    'Docker Inc.'
    'Docker'
    'Evotec'
    'Google'
    'Google Inc'
    'Google Inc.'
    'Hewlett Packard Enterprise Co.'
    'Hewlett Packard Enterprise'
    'Hewlett-Packard Enterprise'
    'Hewlett Packard Enterprise Development LP'
    'HP Development Company L.P.'
    'HP Inc'
    'HPE Storage, A Hewlett Packard Enterprise Company'
    'https://github.com/ebekker/ACMESharp'
    'Ironman Software, LLC'
    'Ironman Software'
    'JDH Information Technology Solutions, Inc.'
    'JumpCloud'
    'Kelverion'
    'Kelverion Automation Limited'
    'Lockstep Technology Group'
    'Microsoft 365 Patterns and Practices'
    'Microsoft (Xbox)'
    'Microsoft Corp'
    'Microsoft Inc.'
    'Microsoft Corporation'
    'Microsoft Corportation'
    'Microsoft Corpration'
    'Microsoft'
    'Microsoft | Services'
    'Microsoft CSS'
    'MicrosoftCorporation'
    'Microsoft Corp.'
    'Microsoft Germany GmbH'
    'Microsoft Support'
    'MosaicMK Software LLC'
    'MosaicMKSoftwareLLC'
    'Mozilla Corporation'
    'Nimble Storage, A Hewlett Packard Enterprise Company'
    'Noveris Pty Ltd'
    'Octopus Deploy Pty. Ltd'
    'Octopus Deploy'
    'Oracle Cloud Infrastructure'
    'Oracle Corporation'
    'Pentia A/S'
    'Pentia'
    'PowerShell.org'
    'Pure Storage, Inc.'
    'Red Gate Software Ltd.'
    'SecureMFA'
    'SecureMFA.com'
    'SolarNet'
    'SolarWinds Worldwide, LLC.'
    'SolarWinds'
    'SynEdgy Limited'
    'Synergex International Corporation'
    'Transitional Data Services, Inc.'
    'VMware'
    'VMware, Inc.'
    'VMware Inc.'
    'Virtual Engine'
    'waldo.be'
    'WebMD Health Services'
    'Worxspace'
    'XtremIO Dell EMC'
    'Yevrag35, LLC.'
    'Zerto Ltd.'
)
$script:regulars = @(
    'BuildHelpers'
    'BurntToast'
    'Carbon'
    'ChocolateyGet'
    'CredentialManager'
    'dbatools'
    'Foil'
    'ImportExcel'
    'Invokebuild'
    'Invoke-CommandAs'
    'oh-my-posh'
    'PendingReboot'
    'PSDepend'
    'PSDeploy'
    'PSKoans'
    'PSLogging'
    'PSSlack'
    'PSWindowsUpdate'
    'Pester'
    'PoshBot'
    'posh-git'
    'Posh-SSH'
    'powershell-yaml'
    'psake'
    'RunAsUser'
    'Selenium'
    'SnipeitPS'
    'SNMP'
    'TeamViewerPS'
    'Write-ObjectToSQL'
)

$domain = 'cloudfront.net'
$target = 'dfuu1myynofuh'
Get-DataLocation
$script:dataFileZip = 'PSGalleryExplorer.zip'
$script:metadataFile = 'PSGalleryExplorer.json'
$script:dataFile = 'PSGalleryExplorer.xml'
$script:dlURI = '{0}.{1}' -f $target, $domain
$script:glData = $null

#endregion
