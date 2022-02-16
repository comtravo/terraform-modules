data "aws_ssm_parameter" "sentry_auth_token" {
  name = "/infrastructure/sentry/sentry_auth_token"
}

data "aws_ssm_parameter" "sentry_url" {
  name = "/infrastructure/sentry/sentry_url"
}

data "aws_ssm_parameter" "sentry_org" {
  name = "/infrastructure/sentry/sentry_org"
}

data "aws_ssm_parameter" "sentry_project" {
  name = "/infrastructure/sentry/sentry_project"
}

resource "null_resource" "sentry_upload_sourcemaps" {
  count = var.enable == true ? 1 : 0

  triggers = {
    lambda_source_code_hash = var.lambda_source_code_hash
  }

  provisioner "local-exec" {
    command = "unzip -o -qq ${var.lambda_file_name} -d $(dirname ${var.lambda_file_name}) && sentry-cli releases files ${var.release} upload-sourcemaps $(dirname ${var.lambda_file_name}) --url-prefix ${var.lambda_name}/"

    environment = {
      SENTRY_URL        = data.aws_ssm_parameter.sentry_url.value
      SENTRY_AUTH_TOKEN = data.aws_ssm_parameter.sentry_auth_token.value
      SENTRY_ORG        = data.aws_ssm_parameter.sentry_org.value
      SENTRY_PROJECT    = data.aws_ssm_parameter.sentry_project.value
    }
  }
}