<#
    .SYNOPSIS
    An Invoke-Build Build file for an AWS PowerShell Lambda Function

    .DESCRIPTION
    This build file is configured for AWS CodeBuild builds, but will work locally as well.

    Build steps can include:
        - InstallDependencies
        - Clean
        - Analyze
        - Test
        - Build
        - Archive

    The default build will not call the 'InstallDependencies' task, but can be used if you want PSDepend
    to install pre-requisite modules. "Invoke-Build -Task InstallDependencies"

    This build will pull in configurations from the "<module>.Settings.ps1" file as well, where users can
    more easily customize the build process if required.

    .EXAMPLE
    Invoke-Build

    This will perform the default build tasks: Clean, Analyze, Test, Build, Archive

    .EXAMPLE
    Invoke-Build -Task Analyze,Test

    This will perform only the Analyze and Test tasks.
#>

# Include: Settings
$ScriptName = (Split-Path -Path $BuildFile -Leaf).Split('.')[0]
. "./$ScriptName.settings.ps1"

# Default Build
task . Clean, ImportModules, Analyze, Build, Publish

# Pre-build variables to configure
Enter-Build {
    $script:LambdaName = (Split-Path -Path $BuildFile -Leaf).Split('.')[0]

    # Identify other required paths
    $script:LambdaSourcePath = $BuildRoot
    $script:LambdaScriptPath = Join-Path -Path $script:LambdaSourcePath -ChildPath "$ScriptName.ps1"
    $script:ArtifactsPath = Join-Path -Path $BuildRoot -ChildPath 'Artifacts'
    $script:ArtifactPackage = Join-Path -Path $script:ArtifactsPath -ChildPath "$ScriptName.zip"
    $script:PowerShellLambdaPath = Split-Path -Path $script:LambdaSourcePath
    $script:StagingPath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'LambdaStaging'

    if ([String]::IsNullOrWhiteSpace($env:CODEBUILD_SRC_DIR)) {
        $script:LambdaFunctionsPath = Split-Path -Path $script:PowerShellLambdaPath
        $script:CodeBuildRoot = Split-Path -Path $script:LambdaFunctionsPath
    }
    else {
        $script:CodeBuildRoot = $env:CODEBUILD_SRC_DIR
    }
    $script:ModulesRoot = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'Modules'
    $script:CFNParameterFilePath = Join-Path -Path $script:CodeBuildRoot -ChildPath 'CloudFormation'

    if (-not(Test-Path -Path $script:CFNParameterFilePath)) {
        throw ('Unable to find the cloudformation Path: {0}' -f $script:CFNParameterFilePath)
    }
}

# Synopsis: Imports PowerShell Modules
task ImportModules {
    Write-Host 'Importing PowerShell Modules'

    $manifests = Get-ChildItem -Path $script:ModulesRoot -Recurse -Filter "*.psd1"
    foreach ($manifest in $manifests) {
        if (Get-Module -Name $manifest.BaseName) {
            Remove-Module -Name $manifest.BaseName
        }

        Write-Host '  -' $manifest.BaseName
        Import-Module $manifest.FullName -Force -Verbose:$false
    }
}

# Synopsis: Clean Artifacts Directory
task Clean {
    foreach ($path in $script:ArtifactsPath, $script:StagingPath) {
        if (Test-Path -Path $path) {
            $null = Remove-Item -Path $path -Recurse -Force
        }

        $null = New-Item -ItemType Directory -Path $path -Force
    }
}

# Synopsis: Invokes Script Analyzer against the Module source path
task Analyze {
    $scriptAnalyzerParams = @{
        Path        = $script:LambdaScriptPath
        Severity    = @('Error', 'Warning')
        Recurse     = $true
        ExcludeRule = @('PSAvoidUsingWriteHost', 'PSUseShouldProcessForStateChangingFunctions')
        Verbose     = $false
    }

    $scriptAnalyzerResults = Invoke-ScriptAnalyzer @scriptAnalyzerParams

    if ($scriptAnalyzerResults) {
        $scriptAnalyzerResults | Format-Table
        throw 'One or more PSScriptAnalyzer errors/warnings where found.'
    }
}

# Synopsis: Builds the Module to the Artifacts folder
task Build {
    Write-Verbose -Message 'Compiling the AWS Lambda Package'
    $script:LambdaPackage = New-AWSPowerShellLambdaPackage -ScriptPath $script:LambdaScriptPath -StagingDirectory $script:StagingPath -OutputPackage $script:ArtifactPackage -Verbose
    Write-Host 'AWS Lambda Function Handler:' $script:LambdaPackage.LambdaHandler
    Write-Host 'PowerShell Function Handler Environment Variable Name:' $script:LambdaPackage.PowerShellFunctionHandlerEnvVar
}

task Publish {
    if ([String]::IsNullOrWhiteSpace($env:CODEBUILD_SRC_DIR) -and [String]::IsNullOrWhiteSpace($env:CODEBUILD_RESOLVED_SOURCE_VERSION)) {
        Write-Warning -Message 'Not publishing the artifact because the code is not running inside a CodeBuild Project'
    }
    else {
        'Publishing Lambda Function to S3'

        $s3Key = '{0}/{1}/lambdafunctions/PowerShell/{2}.zip' -f $env:S3_KEY_PREFIX, $env:CODEBUILD_RESOLVED_SOURCE_VERSION, $ScriptName
        '  - S3Key:/{0}/{1}' -f $env:ARTIFACT_S3_BUCKET, $s3Key

        Write-S3Object -BucketName $env:ARTIFACT_S3_BUCKET -Key $s3Key -File $script:ArtifactPackage

        # Update json parameter files
        $cfnLambdaS3KeyParameterName = 'LMFunctionS3Key{0}' -f $ScriptName
        Write-Verbose -Message "JSON Parameter Name for cloudformation S3 Key: $cfnLambdaS3KeyParameterName" -Verbose

        $cfnLambdaHandlerParameterName = 'LMFunctionHandler{0}' -f $ScriptName
        Write-Verbose -Message "JSON Parameter Name for Lambda Function Handler: $cfnLambdaHandlerParameterName" -Verbose

        $jsonFiles = Get-ChildItem -Path $script:CFNParameterFilePath -Recurse -Filter "*.json"
        foreach ($jsonFile in $jsonFiles) {
            'Processing {0}' -f $jsonFile.Name
            $jsonData = Get-Content -Path $jsonFile.FullName -Raw | ConvertFrom-Json

            # Update cfnLambdaS3KeyParameterName in json parameters
            try {
                $jsonData.Parameters.$cfnLambdaS3KeyParameterName = $s3Key
                '  - Updated the json parameter "{0}" with "{1}".' -f $cfnLambdaS3KeyParameterName, $s3Key
            }
            catch {
                '  - Unable to find the json parameter "{0}". No modifications being made.' -f $cfnLambdaS3KeyParameterName
            }

            # Update cfnLambdaHandlerParameterName in json parameters
            try {
                $jsonData.Parameters.$cfnLambdaHandlerParameterName = $script:LambdaPackage.LambdaHandler
                '  - Updated the json parameter "{0}" with "{1}".' -f $cfnLambdaHandlerParameterName, $script:LambdaPackage.LambdaHandler
            }
            catch {
                '  - Unable to find the json parameter "{0}". No modifications being made.' -f $cfnLambdaHandlerParameterName
            }

            # Export the json back to disk
            $jsonData | ConvertTo-Json | Out-File -FilePath $jsonFile.FullName -Force -Encoding utf8
        }
    }
}