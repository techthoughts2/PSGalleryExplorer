$ErrorActionPreference = 'Stop'

# Paths are based from the root of the GIT repository
$paths = @(
    './CloudFormation'
)

Describe -Name 'JSON Configuration File Validation' -Fixture {

    foreach ($path in $paths) {

        Context -Name $path -Fixture {
            foreach ($file in (Get-ChildItem -Path $path -File -Recurse -Filter '*.json')) {
                Context -Name $file.Name -Fixture {
                    It -Name 'is valid' -Test {
                        { $null = ConvertFrom-Json -InputObject (Get-Content -Path $file.FullName -Raw) } | Should Not Throw
                    }
                }
            }
        }

    }
}