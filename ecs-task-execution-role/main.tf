variable "name" {
  description = "name of the IAM role"
}

resource "aws_iam_role" "this" {
  name                  = var.name
  path                  = "/environment/${terraform.workspace}/"
  force_detach_policies = true

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ecs-tasks.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

data "aws_iam_policy_document" "ecr_pull_access" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "ecr_pull_access" {
  name   = "${var-name}-ecr-pull-access"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.ecr_pull_access.json
}

data "aws_kms_alias" "ssm" {
  name = "alias/aws/ssm"
}

data "aws_iam_policy_document" "ssm_parameter_store_access" {
  statement {
    actions = [
      "ssm:DescribeParameters",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "kms:Decrypt",
      "ssm:GetParameters",
      "ssm:GetParameter",
    ]

    resources = [
      "arn:aws:ssm:${var.region}:${var.ct_account_id}:parameter/${upper(terraform.workspace)}*",
      data.aws_kms_alias.ssm.arn,
    ]
  }
}

resource "aws_iam_role_policy" "ssm_parameter_store_access" {
  name   = "${var-name}-ssm-parameter-store-access"
  role   = aws_iam_role.task_execution_role.id
  policy = data.aws_iam_policy_document.ssm_parameter_store_access.json
}


output "output" {
  description = "IAM role"
  value = aws_iam_role.this
}
