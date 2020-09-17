# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.8.7]

- Added support for including wildcards in ByName ```Find-PSGModule -ByName Posh*```
- Added support for returning all modules ```Find-PSGModule```

## [0.8.5]

- Module Updates:
  - **Support has been added to include information for projects hosted on GitLab**
    - Additional support for other repo locations is planned. As such several references in this module to GitHub have been replaced with Repo or repository.
  - **ByGitHubInfo parameter has been replaced with ByRepoInfo parameter**
  - **ByRecentUpdate parameter options have changed**
    - Previous: GalleryUpdate, GitUpdate
    - New: GalleryUpdate, RepoUpdate
  - **Repository issues is now a returned parameter in all queries**
  - **ByRepoInfo** now has a new parameter choice set:
    - StarCount, Forks, Issues, Subscribers
  - Added additional corps to corp list
  - Minor formatting changes to psd1 manifest
  - ByName selection now always includes all modules
  - The default output has been adjusted:
    - Previous: Name, Downloads, GitStar, GitFork, GitSub, GitWatch, Description
    - New: Name, Downloads, Star, Fork, Issues, Sub, Description
    - All data parameters are still available in the complete object return
- Build Updates:
  - Added CodePipeline capability to deploy Serverless PSGallery solution through code
  - PSGallery lambda changes:
    - Updated to latest versions of used modules
    - A few bug fixes for not being able to properly craft URI
    - Added GitLab query capability
    - Added env variables to comments section
  - Refreshed CodeBuild module build process
    - Added test reporting capability
    - Updated linux CB to latest image and dotnet 3.1
    - Updated windows images to Server 2019
    - pwsh core build now uses PowerShell 7.0.3 instead of 7.0.0
    - refreshed installed modules to latest available versions

## [3/13/2020]

No Version Change

- Build/dev improvements
  - Bumped module versions to latest available
  - Switched Windows Build container to use PowerShell 7 instead of PowerShell 7 preview
  - Updated tasks.json to have better integration with InvokeBuild

## [0.8.0]

### Added

- Initial release.
