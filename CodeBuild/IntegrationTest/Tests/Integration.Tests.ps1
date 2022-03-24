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
        $script:ServiceName = $env:projectName
    } #before_all

    Context -Name 'PSGES3Buckets.yml' {

        It 'Created the S3 buckets needed for the project' -Test {
            $assertion1 = ($cfnExports | Where-Object { $_.Name -eq 'StageTriggerBN' }).Value
            $expected = 'psge-*'
            $assertion1 | Should -BeLike $expected
            $assertion2 = ($cfnExports | Where-Object { $_.Name -eq 'GitXMLDataBN' }).Value
            $expected = 'psge-*'
            $assertion2 | Should -BeLike $expected
            $assertion4 = ($cfnExports | Where-Object { $_.Name -eq 'PubXMLDataBN' }).Value
            $expected = 'psge-*'
            $assertion4 | Should -BeLike $expected
            $logEval = ($cfnExports | Where-Object { $_.Name -eq 'PSGECloudFrontLogBucketBN' }).Value
            $logEval | Should -Not -BeNullOrEmpty
        } #it

        It 'Should create a SNS topic for S3 trigger updates' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq 'UpdateSNSTopicArn' }).Value
            $expected = 'arn:aws:sns:{0}:{1}:*' -f $env:AWSRegion, $env:AWSAccountId
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a CloudFront distribution' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-PSGECloudFrontDistributionDomain" }).Value
            $expected = '*.cloudfront.net'
            $assertion | Should -BeLike $expected
        } #it

    } #context_PSGES3Buckets

    Context -Name 'PSGE.yml' {

        It -Name 'Should create a GitHubDataDlqArn' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-GitHubDataDlqARN" }).Value
            $expected = 'arn:aws:sqs:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a GitHubDataQueueArn' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-GitHubDataQueueARN" }).Value
            $expected = 'arn:aws:sqs:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a GitLabDataDlqARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-GitLabDataDlqARN" }).Value
            $expected = 'arn:aws:sqs:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a GitLabDataQueueARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-GitLabDataQueueARN" }).Value
            $expected = 'arn:aws:sqs:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a UpdatePubXMLDataQueueARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-UpdatePubXMLDataQueueARN" }).Value
            $expected = 'arn:aws:sqs:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a GitHubScannerSMDelayStateMachineARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-GitHubScannerSMDelayStateMachineARN" }).Value
            $expected = 'arn:aws:states:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a GitLabScannerSMDelayStateMachineArn' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-GitLabScannerSMDelayStateMachineArn" }).Value
            $expected = 'arn:aws:states:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a GSScheduledRuleARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-GSScheduledRuleARN" }).Value
            $expected = 'arn:aws:events:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a PubXMLPopulatorARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-PubXMLPopulatorARN" }).Value
            $expected = 'arn:aws:lambda:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a GalleryScannerARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-GalleryScannerARN" }).Value
            $expected = 'arn:aws:lambda:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a GitHubScannerARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-GitHubScannerARN" }).Value
            $expected = 'arn:aws:lambda:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a GitHubSMScannerARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-GitHubSMScannerARN" }).Value
            $expected = 'arn:aws:lambda:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a GitLabScannerARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-GitLabScannerARN" }).Value
            $expected = 'arn:aws:lambda:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a GitLabSMScannerARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-GitLabSMScannerARN" }).Value
            $expected = 'arn:aws:lambda:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a GCombineArn' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-GCombineArn" }).Value
            $expected = 'arn:aws:lambda:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

    } #context_PSGE

    Context -Name 'PSGEAlarms.yml' {

        It -Name 'Should create a GitHubSMFailureAlarmARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-GitHubSMFailureAlarmARN" }).Value
            $expected = 'arn:aws:cloudwatch:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a GitHubSMThrottleAlarmARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-GitHubSMThrottleAlarmARN" }).Value
            $expected = 'arn:aws:cloudwatch:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a GitHubSMTimedOutAlarmARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-GitHubSMTimedOutAlarmARN" }).Value
            $expected = 'arn:aws:cloudwatch:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a GitLabSMThrottleAlarmARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-GitLabSMThrottleAlarmARN" }).Value
            $expected = 'arn:aws:cloudwatch:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a GitLabSMTimedOutAlarmARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-GitLabSMTimedOutAlarmARN" }).Value
            $expected = 'arn:aws:cloudwatch:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a PubXMLMonitorAlarmARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-PubXMLMonitorAlarmARN" }).Value
            $expected = 'arn:aws:cloudwatch:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a PubXMLMonitorARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-PubXMLMonitorARN" }).Value
            $expected = 'arn:aws:lambda:{0}:{1}:*' -f $AWSRegion, $AWSAccountID
            $assertion | Should -BeLike $expected
        } #it

    } #context_PSGEAlarms

} #describe_infra_tests
