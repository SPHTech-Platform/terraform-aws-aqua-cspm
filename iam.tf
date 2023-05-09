resource "aws_iam_policy" "aqua_cspm_lambda" {
  name        = "${local.name_prefix}-lambda-policy"
  description = "Aqua CSPM Lambda Function Policy"
  policy      = data.aws_iam_policy_document.aqua_cspm_lambda.json

}

module "lambda_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 5.9.0"

  create_role = true

  role_name        = "${local.name_prefix}-lambda-role"
  role_description = "Assumable Role of Aqua CSPM Lambda Function"

  trusted_role_services = [
    "lambda.amazonaws.com"
  ]

  role_requires_mfa = false

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    aws_iam_policy.aqua_cspm_lambda.arn,
  ]
}

resource "aws_iam_policy" "aqua_cspm_supplemental" {
  name        = "${local.name_prefix}-supplemental-policy"
  description = "Aqua CSPM Supplemental Policy"
  policy      = data.aws_iam_policy_document.aqua_cspm_supplemental.json
}

resource "aws_iam_role" "aqua_cspm" {
  name        = "${local.name_prefix}-role"
  description = "Assumable Role of Aqua SaaS"

  path                 = "/"
  max_session_duration = "3600"

  assume_role_policy = data.aws_iam_policy_document.aqua_cspm_custom_trust.json

  depends_on = [
    aws_lambda_invocation.external_id,
  ]
}

resource "aws_iam_role_policy_attachment" "aqua_cspm" {
  count = length(local.aqua_cspm_role_policy_arns)

  policy_arn = element(local.aqua_cspm_role_policy_arns, count.index)
  role       = aws_iam_role.aqua_cspm.name
}


resource "aws_iam_policy" "aquasec_importfindings" {
  count = local.enable_security_hub_integration ? 1 : 0

  name_prefix = "${local.name_prefix}-sechub-import-findings-"
  policy      = data.aws_iam_policy_document.aquasec_importfindings.json
}

resource "aws_iam_role" "aqua_cspm_sechub" {
  count = local.enable_security_hub_integration ? 1 : 0

  depends_on = [
    aws_lambda_invocation.sechub_integration_external_id,
  ]

  name        = "${local.name_prefix}-sechub-import-role"
  description = "Role assumed by AquaSec for importing Sechub findings from CSPM"

  path                 = "/"
  max_session_duration = "3600"

  assume_role_policy = data.aws_iam_policy_document.aquahub_sechub_trust.json
}

resource "aws_iam_role_policy_attachment" "aqua_cspm_sechub" {
  count = local.enable_security_hub_integration ? 1 : 0

  policy_arn = aws_iam_policy.aquasec_importfindings[0].arn
  role       = aws_iam_role.aqua_cspm_sechub[0].name
}
