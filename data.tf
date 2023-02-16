data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}

data "aws_iam_policy_document" "aqua_cspm_secret" {

  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue"
    ]

    principals {
      type        = "AWS"
      identifiers = aws_iam_role.lambda_role.arn
    }

    resources = [
      aws_secretsmanager_secret.aqua_cspm_secret.arn
    ]
  }
}

data "aws_iam_policy_document" "aqua_cspm_control_tower_kms_key" {

  statement {
    sid = "Allow administration of the key"

    effect = "Allow"

    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
    ]

    principals {
      type        = "AWS"
      identifiers = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
    }

    resources = [
      "*"
    ]
  }

  statement {
    sid = "Allow use of the key"

    effect = "Allow"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt",
      "kms:GenerateDataKey",
      "kms:CreateGrant",
      "kms:DescribeKey",
    ]

    principals {
      type        = "AWS"
      identifiers = data.aws_caller_identity.current.account_id
    }

    resources = [
      "*"
    ]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values = [
        "secretsmanager.${data.aws_region.current.name}.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values = [
        data.aws_caller_identity.current.account_id
      ]
    }
  }
}

