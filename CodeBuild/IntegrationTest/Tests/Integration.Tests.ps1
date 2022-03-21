# $env:ARTIFACT_S3_BUCKET = the artifact bucket used by CB
# $env:AWSAccountId = the AWS Account hosting the service under test
# $env:AWSRegion = the AWS Region hosting the service under test
# $env:projectName = name of the project

Describe -Name 'Infrastructure Tests' -Fixture {
    BeforeAll {
        try {
            $cfnExports = Get-CFNExport -ErrorAction Stop
        }
        catch {
            throw
        }
    } #before_all

    Context -Name 'PSGES3Buckets.yml' -Fixture {

        It -Name 'Created the S3 buckets needed for the project' -Test {
            $assertion1 = ($cfnExports | Where-Object { $_.Name -eq 'StageTriggerBN' }).Value
            $expected = 'psge-*'
            $assertion1 | Should -BeLike $expected
            $assertion2 = ($cfnExports | Where-Object { $_.Name -eq 'GitXMLDataBN' }).Value
            $expected = 'psge-*'
            $assertion2 | Should -BeLike $expected
            $assertion4 = ($cfnExports | Where-Object { $_.Name -eq 'PubXMLDataBN' }).Value
            $expected = 'psge-*'
            $assertion4 | Should -BeLike $expected
            $logEval = ($cfnExports | Where-Object { $_.Name -eq 'S3BucketLogsBN' }).Value
            $logEval | Should -Not -BeNullOrEmpty
        } #it

        It -Name 'Should create a SNS topic for S3 trigger updates' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq 'UpdateSNSTopicArn' }).Value
            $expected = 'arn:aws:sns:{0}:{1}:*' -f $env:AWSRegion, $env:AWSAccountId
            $assertion | Should -BeLike $expected
        } #it

    } #context_PSGES3Buckets

} #describe_infra_tests