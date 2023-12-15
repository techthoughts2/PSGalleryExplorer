# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

- Build Updates
    - AWS Deployment Updates
        - Updated CodeBuild containers from `aws/codebuild/standard:6.0` to `aws/codebuild/standard:7.0`

## [2.5.0]

- Module Updates
    - Added support for usage of a metadata file to better determine if data is current
        - Added `Confirm-MetadataUpdate` private function
        - Updated logic in `Confirm-XMLDataSet` and `Invoke-XMLDataCheck`
        - Removed private function `Get-XMLDataSet` for new private function `Get-RemoteFile`
    - Convert `1.5.0` or higher now required
    - Added the `InsightView` parameter to both `Find-ModuleByCommand` and `Find-PSGModule`
        - This provides a new results view that focuses on community insights
- Build Updates
    - SSM Task now copies metadata file
    - InvokeBuild bumped from `5.10.2` to `5.10.3`
    - Convert bumped from `1.2.0` to `1.5.0`
    - Removed all test case uses of `Assert-MockCalled`
    - Improved test formatting
    - Updated test example references
    - Added additional integration tests for new properties

## [2.1.0]

- Module Updates
    - New function: `Find-ModuleByCommand`

## [2.0.0] - *Breaking Changes Introduced*

- Module Updates
    - **New CDN Endpoint** - ***Breaking Change***
        - PSGalleryExplorer has migrated to a new CDN endpoint for serving repository information. As a result, the old endpoint has been decommissioned.
            - *What does this mean?*
                - Older versions of PSGalleryExplorer (prior to `v2.0.0`) will no longer be able to fetch module project information due to the new CDN endpoint. If you're using an older version, please upgrade to v2.0.0 or later to continue using PSGalleryExplorer.
    - Convert `1.2.0` or higher now required
    - Added additional corps to list
    - Added additional regulars to list
- Build Updates:
    - Moved from a fully serverless PowerShell lambda architecture to a hybrid SSM execution architecture.
    - Added integration for Read the Docs
    - Moved `CHANGELOG.md` from `.github` directory to `docs` directory
    - Updated VSCode `tasks.json`
    - Added a `SECURITY.md` file for the project
    - All Infra/Infrastructure references changed to Integration
    - CI/CD Changes:
        - Pester bumped from `5.3.1` to `5.4.0`
        - InvokeBuild bumped from `5.9.7` to `5.10.2`
        - PSScriptAnalyzer bumped from `1.20.0` to `1.21.0`
        - Convert bumped from `0.6.0` to `1.2.0`
        - Switched AWS module install to use PSGallery
        - Updated CodeBuild Linux image from `aws/codebuild/standard:5.0` to `aws/codebuild/standard:6.0`
        - Updated CodeBuild Windows image from `aws/codebuild/windows-base:2019-1.0` to `aws/codebuild/windows-base:2019-2.0`
        - Added log retention groups to all CodeBuild projects

## [1.0.2]

- Added additional corps to list
- Added additional regulars to list
- Changed column output for module name from 15 to 20 characters

## [1.0.0]

- Module Updates
    - Module manifest
        - Added additional tags
        - Bumped Convert requirement to `0.6.0`
    - Separated Pester unit tests into separate test folders
    - Added support for Pester 5
    - Minor formatting changes to most functions
- Build Updates:
    - Refreshed CodeBuild module build process
        - Minor updates to AWS CodeBuild buildspec files
            - pwsh_windows updated to utilize native pwsh using dotnet 3.1
        - refreshed installed modules to latest available versions
    - Appveyor MacOS now produces artifacts
    - Updated PSGalleryExplorer.build file to align with latest bug fixes
    - Updated CodeBuild images to latest available
    - Added support for using new main branch instead of master
    - Updated CodeBuild image from `aws/codebuild/amazonlinux2-x86_64-standard:3.0` to `aws/codebuild/standard:5.0`
    - Added tagging to Lambda log groups
    - ***Updated all lambdas from `.NET 3.1` to `.NET 6`***
    - Bumped all PowerShell module versions to latest version
    - Added Pester 5 support
    - XML file generation is now sent to cloudfront
    - Added cloudfront logging
    - Added additional monitoring and alarms
- Minor updates to VSCode settings/tasks/extension files

## [0.8.7]

- Added support for including wildcards in ByName `Find-PSGModule -ByName Posh*`
- Added support for returning all modules `Find-PSGModule`

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
