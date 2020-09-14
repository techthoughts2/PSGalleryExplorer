# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.8.2]

- Module Updates:
  - Added additional corps to corp list
  - Minor formatting changes to psd1 manifest
  - ByName selection now always includes all modules
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
