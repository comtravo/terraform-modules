provider "aws" {
  region                      = "us-east-1"
  s3_force_path_style         = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  access_key                  = "This is not an actual access key."
  secret_key                  = "This is not an actual secret key."

  endpoints {
    ec2     = "http://localstack:4597"
    iam     = "http://localstack:4593"
    route53 = "http://localstack:4580"
    sts     = "http://localstack:4592"
  }
}
