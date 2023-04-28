data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}

data "aws_iam_policy_document" "aqua_cspm_secret" {

  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
    ]

    principals {
      type        = "AWS"
      identifiers = [module.lambda_role.iam_role_arn]
    }

    resources = [
      aws_secretsmanager_secret.aqua_cspm_secret.arn,
    ]
  }
}

data "aws_iam_policy_document" "aqua_cspm_control_tower_kms_key" {
  #checkov:skip=CKV_AWS_109
  #checkov:skip=CKV_AWS_111
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
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    resources = [
      "*",
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
      identifiers = [data.aws_caller_identity.current.account_id]
    }

    resources = [
      "*",
    ]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values = [
        "secretsmanager.${data.aws_region.current.name}.amazonaws.com",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values = [
        data.aws_caller_identity.current.account_id,
      ]
    }
  }
}

data "aws_iam_policy_document" "aqua_cspm_lambda" {
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      aws_secretsmanager_secret.aqua_cspm_secret.id,
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "kms:Decrypt",
    ]

    resources = [
      module.kms.key_arn,
    ]
  }
}

data "aws_iam_policy_document" "aqua_cspm_supplemental" {
  statement {
    effect = "Allow"

    actions = [
      "compute-optimizer:GetEC2InstanceRecommendations",
      "compute-optimizer:GetAutoScalingGroupRecommendations",
      "imagebuilder:ListInfrastructureConfigurations",
      "imagebuilder:ListImageRecipes",
      "imagebuilder:ListContainerRecipes",
      "imagebuilder:ListComponents",
      "ses:DescribeActiveReceiptRuleSet",
      "athena:GetWorkGroup",
      "logs:DescribeLogGroups",
      "logs:DescribeMetricFilters",
      "config:getComplianceDetailsByConfigRule",
      "elastictranscoder:ListPipelines",
      "elasticfilesystem:DescribeFileSystems",
      "servicequotas:ListServiceQuotas",
      "ssm:ListAssociations",
      "dlm:GetLifecyclePolicies",
      "airflow:ListEnvironments",
      "glue:GetSecurityConfigurations",
      "devops-guru:ListNotificationChannels",
      "ec2:GetEbsEncryptionByDefault",
      "ec2:GetEbsDefaultKmsKeyId",
      "organizations:ListAccounts",
      "kendra:ListIndices",
      "proton:ListEnvironmentTemplates",
      "qldb:ListLedgers",
      "airflow:ListEnvironments",
      "profile:ListDomains",
      "timestream:DescribeEndpoints",
      "timestream:ListDatabases",
      "frauddetector:GetDetectors",
      "memorydb:DescribeClusters",
      "kafka:ListClusters",
      "apprunner:ListServices",
      "finspace:ListEnvironments",
      "healthlake:ListFHIRDatastores",
      "codeartifact:ListDomains",
      "auditmanager:GetSettings",
      "appflow:ListFlows",
      "databrew:ListJobs",
      "managedblockchain:ListNetworks",
      "connect:ListInstances",
      "backup:ListBackupVaults",
      "backup:DescribeRegionSettings",
      "backup:getBackupVaultNotifications",
      "backup:ListBackupPlans",
      "backup:GetBackupVaultAccessPolicy",
      "backup:GetBackupPlan",
      "dlm:GetLifecyclePolicies",
      "glue:GetSecurityConfigurations",
      "ssm:describeSessions",
      "ssm:GetServiceSetting",
      "ecr:DescribeRegistry",
      "ecr-public:DescribeRegistries",
      "kinesisvideo:ListStreams",
      "wisdom:ListAssistants",
      "voiceid:ListDomains",
      "lookoutequipment:ListDatasets",
      "iotsitewise:DescribeDefaultEncryptionConfiguration",
      "geo:ListTrackers",
      "geo:ListGeofenceCollections",
      "lookoutvision:ListProjects",
      "lookoutmetrics:ListAnomalyDetectors",
      "lex:ListBots",
      "forecast:ListDatasets",
      "forecast:ListForecastExportJobs",
      "forecast:DescribeDataset",
      "lambda:GetFunctionUrlConfig",
      "cloudwatch:GetMetricStatistics",
      "geo:DescribeTracker",
      "connect:ListInstanceStorageConfigs",
      "lex:ListBotAliases",
      "lookoutvision:ListModels",
      "geo:DescribeGeofenceCollection",
      "codebuild:BatchGetProjects",
      "profile:GetDomain",
      "lex:DescribeBotAlias",
      "lookoutvision:DescribeModel",
      "s3:ListBucket",
      "frauddetector:GetKMSEncryptionKey",
      "imagebuilder:ListImagePipelines",
      "compute-optimizer:GetRecommendationSummaries",
      "cloudtrail:DescribeTrails",
      "rds:DescribeDBInstances",
      "ec2:DescribeSecurityGroups",
      "EC2:describeVpcs",
      "EC2:describeInstances",
      "ELB:describeLoadBalancers",
      "Lambda:listFunctions",
      "RDS:describeDBInstances",
      "Redshift:describeClusters",
      "EC2:describeVolumes",
      "KMS:describeKey",
      "KMS:listKeys",
      "STS:getCallerIdentity",
      "EC2:describeInstances",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "aqua_cspm_custom_trust" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::057012691312:role/uwbwh-lambda-cloudsploit-api"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [
        local.external_id,
      ]
    }

    # condition {
    #   test     = "IpAddress"
    #   variable = "aws:SourceIp"
    #   values = [
    #     local.public_ip,
    #   ]
    # }
  }

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::057012691312:role/uwbwh-lambda-cloudsploit-collector"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [
        local.external_id,
      ]
    }

    # condition {
    #   test     = "IpAddress"
    #   variable = "aws:SourceIp"
    #   values = [
    #     local.public_ip,
    #   ]
    # }
  }

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::057012691312:role/uwbwh-lambda-cloudsploit-remediator"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [
        local.external_id,
      ]
    }

    # condition {
    #   test     = "IpAddress"
    #   variable = "aws:SourceIp"
    #   values = [
    #     local.public_ip,
    #   ]
    # }
  }

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::057012691312:role/uwbwh-lambda-cloudsploit-tasks"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [
        local.external_id,
      ]
    }

    # condition {
    #   test     = "IpAddress"
    #   variable = "aws:SourceIp"
    #   values = [
    #     local.public_ip,
    #   ]
    # }
  }

  depends_on = [
    aws_lambda_invocation.external_id,
  ]
}
