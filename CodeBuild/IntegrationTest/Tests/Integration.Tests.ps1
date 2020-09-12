# $env:ARTIFACT_S3_BUCKET = the artifact bucket used by CB
# $env:AWSAccountId = the AWS Account hosting the service under test
# $env:AWSRegion = the AWS Region hosting the service under test
# $env:projectName = name of the project

try {
    $cfnExports = Get-CFNExport -ErrorAction Stop
}
catch {
    throw
}

Describe -Name 'Infrastructure Tests' -Fixture {

    Context -Name 'PSGES3Buckets.yml' -Fixture {
        It -Name 'Created the S3 buckets needed for the project' -Test {
            $assertion1 = ($cfnExports | Where-Object { $_.Name -eq "StageTriggerBN" }).Value
            $expected = 'psge-*'
            $assertion1 | Should -BeLike $expected
            $assertion2 = ($cfnExports | Where-Object { $_.Name -eq "GitXMLDataBN" }).Value
            $expected = 'psge-*'
            $assertion2 | Should -BeLike $expected
            $assertion4 = ($cfnExports | Where-Object { $_.Name -eq "PubXMLDataBN" }).Value
            $expected = 'psge-*'
            $assertion4 | Should -BeLike $expected
            $logEval = ($cfnExports | Where-Object { $_.Name -eq "S3BucketLogsBN" }).Value
            $logEval | Should -Not -BeNullOrEmpty
        }#it
    }#context_IntegrationTestInfrastructure

}#describe_infra_tests