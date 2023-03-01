# PSGalleryExplorer

[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://github.com/PowerShell/PowerShell) [![PowerShell Gallery][psgallery-img]][psgallery-site] ![Cross Platform](https://img.shields.io/badge/platform-windows%20%7C%20macos%20%7C%20linux-lightgrey) [![License][license-badge]](LICENSE) [![Documentation Status](https://readthedocs.org/projects/psgalleryexplorer/badge/?version=latest)](https://psgalleryexplorer.readthedocs.io/en/latest/?badge=latest)

[psgallery-img]:   https://img.shields.io/powershellgallery/dt/PSGalleryExplorer?label=Powershell%20Gallery&logo=powershell
[psgallery-site]:  https://www.powershellgallery.com/packages/PSGalleryExplorer
[psgallery-v1]:    https://www.powershellgallery.com/packages/PSGalleryExplorer/0.8.0
[license-badge]:   https://img.shields.io/github/license/techthoughts2/PSGalleryExplorer

<p align="center">
    <img src="assets/PSGalleryExplorer.png" alt="PSGalleryExplorer Logo" >
</p>

## What is PSGalleryExplorer?

PSGalleryExplorer is a PowerShell module that extends the search functionality of the PowerShell Gallery by providing additional project information about modules. This enables you to search, explore, and discover PowerShell Gallery modules based on additional criteria.

PSGalleryExplorer is not intended to replace `Find-Module`. Rather, it complements it by providing a means to discover modules and gain insights into their associated project repositories. PSGalleryExplorer enables you to expand your exploration of the PowerShell Gallery, identifying new, trending, and modules with heavy community involvement.



## Why PSGalleryExplorer?

To aid in the discoverability of modules in the PowerShell Gallery.

The current PowerShell Gallery search options are primarily limited to module name, and tags. CI/CD processes also inflate the download numbers of many modules on the gallery. This makes it challenging to get a sense of new or trending modules, or modules that the community is engaging with.

This project aims to increase the discoverability of modules on the PowerShell Gallery and encourage module exploration.

For example, when exploring what is available for adding message functionality, PSGalleryExplorer provides repo statistics on the associated projects (when available), such as star count and issues, giving you a better understanding of the module's community involvement and overall health.

`Find-Module` Example:

```powershell
Find-Module -Tag message

Version       Name             Repository    Description
-------       ----             ----------    -----------
1.0.6         PSSlack          PSGallery     PowerShell module for the Slack API
2.3.0         PoshGram         PSGallery     PoshGram provides functionality to send various message t…
0.3.5         PSRabbitMq       PSGallery     Send and receive messages using a RabbitMQ server
1.1.0         Environment      PSGallery     Provides Trace-Message, and functions for working with En…
0.6.0         GitUtils         PSGallery     A set of functions for git tasks
0.0.1         Send-Message     PSGallery     Show popup message box on local or remote computers
0.0.8         PSRyver          PSGallery     Community PowerShell module for the Ryver API
1.0.0.0       MessageBox       PSGallery     Easy to use to create a popup message box
```

PSGalleryExplorer Example:

```powershell
Find-PSGModule -ByTag message -IncludeCorps -IncludeRegulars

Name             Downloads    Star    Fork  Issues    Sub Description
----             ---------    ----    ----  ------    --- -----------
PSSlack           10390604     255      72      41     29 PowerShell module for the Slack API
PoshGram             81268     115      11       4     10 PoshGram provides functionality to send various message types to a specif…
PSRabbitMq           21769      42      28       2      9 Send and receive messages using a RabbitMQ server
Environment           2091      24       2       0      3 Provides Trace-Message, and functions for working with Environment and Pa…
GitUtils               783                                A set of functions for git tasks
PSRyver                449       0       0       0      2 Community PowerShell module for the Ryver API
MessageBox             439                                Easy to use to create a popup message box
Send-Message           411                                Show popup message box on local or remote computers
```

## Getting Started

### Installation

```powershell
# Install PSGalleryExplorer from the PowerShell Gallery
Install-Module -Name PSGalleryExplorer -Repository PSGallery -Scope CurrentUser
```

### Quick start

```powershell
#------------------------------------------------------------------------------------------------
# import the PSGalleryExplorer module
Import-Module -Name "PSGalleryExplorer"
#------------------------------------------------------------------------------------------------
# discover module info by tag
Find-PSGModule -ByTag Telegram
#------------------------------------------------------------------------------------------------
# discover PowerShell modules by # of Gallery Downloads
Find-PSGModule -ByDownloads
#------------------------------------------------------------------------------------------------
# discover the most recently updated modules on repo
Find-PSGModule -ByRecentUpdate RepoUpdate
#------------------------------------------------------------------------------------------------
# discover the most recently updated modules on the PowerShell Gallery
Find-PSGModule -ByRecentUpdate GalleryUpdate
#------------------------------------------------------------------------------------------------
# discover PowerShell modules by # of Gallery Downloads
# include corporate modules and common/popular modules in results
# return top 50
Find-PSGModule -ByDownloads -IncludeCorps -IncludeRegulars -NumberToReturn 50
#------------------------------------------------------------------------------------------------
# discover PowerShell modules by # of repo project stars
Find-PSGModule -ByRepoInfo StarCount
#------------------------------------------------------------------------------------------------
# discover PowerShell modules that could possibly use some help
Find-PSGModule -ByRepoInfo Issues
#------------------------------------------------------------------------------------------------
# discover PowerShell modules by # of repo project subscribers
Find-PSGModule -ByRepoInfo Subscribers
#------------------------------------------------------------------------------------------------
# discover a set of random modules
Find-PSGModule -ByRandom
#------------------------------------------------------------------------------------------------
# discover module info by name
Find-PSGModule -ByName 'PoshGram'
#------------------------------------------------------------------------------------------------
```

## How PSGalleryExplorer Works

PSGalleryExplorer uses a workflow to collect and serve information about module repositories. It scrapes repository data for modules that have public repositories, then aggregates and includes that data in an easy-to-read format.

## Features

- Fully cross-platform and can be run on Windows, Linux, and macOS
- Discover modules based on various criteria such as number of downloads, stars, forks, and more
- Get insights into the community health of a module's repository, including information about open issues, license, and last updated date
- Identify modules that are actively being developed by filtering based on their most recent repository update date.
- Compliments existing tools like `Find-Module` to provide another way to explore modules on the PowerShell Gallery.
- Identify up-and-coming or trending modules by comparing search results including and excluding popular and corporate modules
- PSGalleryExplorer provides a detailed, informative output of module results to help you quickly identify prime candidates for further exploration.
