# PSGalleryExplorer

[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://github.com/PowerShell/PowerShell) [![PowerShell Gallery][psgallery-img]][psgallery-site] ![Cross Platform](https://img.shields.io/badge/platform-windows%20%7C%20macos%20%7C%20linux-lightgrey) [![License][license-badge]](LICENSE) [![Documentation Status](https://readthedocs.org/projects/psgalleryexplorer/badge/?version=latest)](https://psgalleryexplorer.readthedocs.io/en/latest/?badge=latest)

[psgallery-img]:   https://img.shields.io/powershellgallery/dt/PSGalleryExplorer?label=Powershell%20Gallery&logo=powershell
[psgallery-site]:  https://www.powershellgallery.com/packages/PSGalleryExplorer
[psgallery-v1]:    https://www.powershellgallery.com/packages/PSGalleryExplorer/0.8.0
[license-badge]:   https://img.shields.io/github/license/techthoughts2/PSGalleryExplorer

<p align="center">
    <img src="docs/assets/PSGalleryExplorer.png" alt="PSGalleryExplorer Logo" >
</p>

Branch | Windows | Windows pwsh | MacOS | Linux
--- | --- | --- | --- | --- |
main | ![M-W-Build Status](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiYURpTUhFRkQ0aXZMMWRnTEl3U2x3Q0VaYWtNWHFEVTBuOTNhaXZLV1ZNczNWc0tHUEJkdzhDajR0Q2pERXl0c3huM01DdVliU3YzU3NwT0hnNHM5Rm5VPSIsIml2UGFyYW1ldGVyU3BlYyI6Ikk4Z1hDdENXZ0RZSDdoaXUiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=main) | ![M-W-pwsh-Build Status](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoicGN3NzBiY1dPRlRPSXpsQmF5dEJ6aTVVWWx4a3h6M2R6dTA1dmF2UmxEWUppOWpwR0hMU3lINUdxMElCUlJIc0RWRTZFSzRlNXM2S2RMY3UzdlZaRnFRPSIsIml2UGFyYW1ldGVyU3BlYyI6InZUbVhaMjBlc09KQWVlckMiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=main) | [![M-Mac-Build status](https://ci.appveyor.com/api/projects/status/s28ivs5pavul6usq/branch/main?svg=true)](https://ci.appveyor.com/project/techthoughts2/psgalleryexplorer/branch/main) | ![M-L-Build Status](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiRDBjRkVOTVhHTmJybmRFZ216QlM1ekNEMjBMR3paN3VNMUlHMW9QNXIwaUxIQU5oUm9pbVZtZndWSEl3Mzh6YVQ3NitCREk2YnRoVjJMYUtBcno4WlRVPSIsIml2UGFyYW1ldGVyU3BlYyI6IjRaWFJ6dXMzOFdFaWVWM0giLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=main) |
Enhancements | ![E-W-Build Status](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoidFV4dnZKQmd4cHZMSE0zdFRmQml0NDMvZzh4cGJzMVEwbGFTQVBaMmpya2tRcTJXbXZmV00xeGF0WUpST0lJczFoRTROUitlZXAvWGNpN3ErV0s1VWVnPSIsIml2UGFyYW1ldGVyU3BlYyI6IlA2aUQyYm9OSWswS2Q5ZEciLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=Enhancements) | ![E-W-pwsh-Build Status](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiWlAyKzRLYVFybDdLdjJFcHdkeHNpcTdxZnRFMytJeVVYRWRCTUN6SFZVRENrZW51dHlnOFVydS9CMkp0YnhiQlY4WDV0YmlmdFBUUy96S1ZLT1BVdnVrPSIsIml2UGFyYW1ldGVyU3BlYyI6InRaUDIvS3Vnb2dMbkEyQVciLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=Enhancements) | [![E-Mac-Build status](https://ci.appveyor.com/api/projects/status/s28ivs5pavul6usq/branch/Enhancements?svg=true)](https://ci.appveyor.com/project/techthoughts2/psgalleryexplorer/branch/Enhancements)| ![E-L-Build Status](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiQmRrOU9HOUppVHAxRVNhZlpTT3BNU2phSzRSSVQ3aysyemRDSjJiU3NDZEU1QzRDNlBMM0Jnai9qb2RNektUWktudUp3OWN6UTJQZEFnZlNZRG1GZ3ZZPSIsIml2UGFyYW1ldGVyU3BlYyI6IlVudjNoc3JaMnZQU2ljV1UiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=Enhancements) |

## Synopsis

PSGalleryExplorer is a PowerShell module that extends the search functionality of the PowerShell Gallery by providing additional project information about modules. This enables you to search, explore, and discover PowerShell Gallery modules based on additional criteria.

![PSGalleryExplorer Gif Demo](docs/assets/psgalleryexplorer.gif)

## Description

PSGalleryExplorer is a PowerShell module that extends the search functionality of the PowerShell Gallery by providing additional project information about modules. It enables users to search, explore, and discover PowerShell Gallery modules based on additional criteria that are not available via `Find-Module`. The module provides various features such as filtering results based on download counts, stars, forks, and repository health metrics like open issues, license, and last updated date. With PSGalleryExplorer, users can easily identify trending and actively developed modules, and explore module repositories directly from the console.

### Features

- Fully cross-platform and can be run on Windows, Linux, and macOS
- Discover modules based on various criteria such as number of downloads, stars, forks, and more
- Get insights into the community health of a module's repository, including information about open issues, license, and last updated date
- Identify modules that are actively being developed by filtering based on their most recent repository update date.
- Compliments existing tools like `Find-Module` to provide another way to explore modules on the PowerShell Gallery.
- Identify up-and-coming or trending modules by comparing search results including and excluding popular and corporate modules
- PSGalleryExplorer provides a detailed, informative output of module results to help you quickly identify prime candidates for further exploration.

## Getting Started

### Documentation

Documentation for PSGalleryExplorer is available at: [https://psgalleryexplorer.readthedocs.io](https://psgalleryexplorer.readthedocs.io)

### Installation

```powershell
# Install PSGalleryExplorer from the PowerShell Gallery
Install-Module -Name "PSGalleryExplorer" -Repository PSGallery -Scope CurrentUser
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

## Notes

This PowerShell project was created with [Catesta](https://github.com/techthoughts2/Catesta).

## Contributing

If you'd like to contribute to PSGalleryExplorer, please see the [contribution guidelines](.github/CONTRIBUTING.md).

## License

This project is [licensed under the MIT License](LICENSE).
