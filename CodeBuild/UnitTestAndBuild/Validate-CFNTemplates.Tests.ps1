$ErrorActionPreference = 'Stop'

$paths = @(
    './CloudFormation'
)

Describe -Name 'CloudFormation Template Validation' -Fixture {

    foreach ($path in $paths) {

        foreach ($file in (Get-ChildItem -Path $path -Recurse | Where-Object { $_.Extension -eq '.yml' })) {
            $rnd = Get-Random -Minimum 2 -Maximum 7
            Start-Sleep -Seconds $rnd
            Context -Name $file.Name -Fixture {
                It -Name 'is valid' -Test {
                    { Test-CFNTemplate -TemplateBody (Get-Content -Path $file.FullName -Raw) } | Should Not Throw
                }
            }
        }

    }
}