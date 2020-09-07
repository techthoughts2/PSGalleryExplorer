'Configurating AWS credentials'

'  - Retrieving temporary credentials from metadata'
$uri = 'http://169.254.170.2{0}' -f $env:AWS_CONTAINER_CREDENTIALS_RELATIVE_URI
$sts = Invoke-RestMethod -UseBasicParsing -Uri $uri

'  - Setting default AWS Credential'
$credentialsFile = '~/.aws/credentials'
$null = New-Item -Path $credentialsFile -Force

'[default]' | Out-File -FilePath $credentialsFile -Append
'aws_access_key_id={0}' -f $sts.AccessKeyId | Out-File -FilePath $credentialsFile -Append
'aws_secret_access_key={0}' -f $sts.SecretAccessKey | Out-File -FilePath $credentialsFile -Append
'aws_session_token={0}' -f $sts.Token | Out-File -FilePath $credentialsFile -Append

'  - Setting default AWS Region'
$null = New-Item -Path $profile -Force
'$StoredAWSRegion = "{0}"' -f $env:AWS_DEFAULT_REGION | Out-File -FilePath $profile -Force

'  - AWS credentials configured'