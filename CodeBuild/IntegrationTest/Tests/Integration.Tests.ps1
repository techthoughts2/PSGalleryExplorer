# $env:ARTIFACT_S3_BUCKET = the artifact bucket used by CB
# $env:AWSAccountId = the AWS Account hosting the service under test
# $env:AWSRegion = the AWS Region hosting the service under test
# $env:projectName = name of the project

Describe -Name 'Infrastructure Tests' -Fixture {

    Context -Name 'TestIAM.yml' -Fixture {
        It -Name 'Created a CFN Export for a Test IAM Role' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$env:projectName-TestSNSArn" }).Value
            $expected = 'arn:aws:sns:{0}:{1}:*' -f $env:AWSRegion, $env:AWSAccountId
            $assertion | Should -BeLike $expected
        }#it
    }#context_IntegrationTestInfrastructure

}#describe_infra_tests