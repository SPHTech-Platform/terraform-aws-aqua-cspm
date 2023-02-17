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

module "aqua_cspm_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 5.9.0"

  create_role = true

  role_name        = "${local.name_prefix}-role"
  role_description = "Assumable Role of Aqua SaaS"

  custom_role_trust_policy = data.aws_iam_policy_document.aqua_cspm_custom_trust.json

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/SecurityAudit",
    aws_iam_policy.aqua_cspm_supplemental.arn,
  ]
}
