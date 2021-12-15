variable "name" {
  description = "Name of the IAM role"
  type        = "string"
}


data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_kms_alias" "ssm" {
  name = "alias/aws/ssm"
}

output "role" {
  value       = aws_iam_role.task_execution_role
  description = "IAM Role attributes"
}


resource "aws_iam_role" "task_execution_role" {
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
  name   = "ecs-ecr-access"
  role   = aws_iam_role.task_execution_role.id
  policy = data.aws_iam_policy_document.ecr_pull_access.json
}


data "aws_iam_policy_document" "cloudwatch_logs_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "cloudwatch_logs_policy" {
  name   = "ecs-cwl-policy"
  role   = aws_iam_role.task_execution_role.id
  policy = data.aws_iam_policy_document.cloudwatch_logs_policy.json
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
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${upper(terraform.workspace)}*",
      data.aws_kms_alias.ssm.arn,
    ]
  }
}

resource "aws_iam_role_policy" "ssm_parameter_store_access" {
  name   = "ecs-ssm-access-${terraform.workspace}"
  role   = aws_iam_role.task_execution_role.id
  policy = data.aws_iam_policy_document.ssm_parameter_store_access.json
}
