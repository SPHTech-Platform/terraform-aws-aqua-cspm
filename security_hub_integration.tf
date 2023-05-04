module "sechub_integration_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.10.1"

  function_name = "${local.name_prefix}-sechub-integration-function"
  description   = "Retrieves the External ID from Aqua CSPM"
  handler       = "index.lambda_handler"
  runtime       = "python3.9"

  memory_size = 128
  timeout     = 30

  create_package         = false
  local_existing_package = "${path.module}/src/security_hub_integration_function/lambda_function.zip"

  create_role = false
  lambda_role = module.lambda_role.iam_role_arn

  tags = var.tags
}

resource "aws_lambda_invocation" "sechub_integration_external_id" {
  function_name = module.sechub_integration_lambda.lambda_function_name
  input = jsonencode({
    ResourceProperties = {
      Secret = local.secret_name
    },
    LogicalResourceId = "ExternalIDInvoke"
  })

  depends_on = [
    module.sechub_integration_lambda,
    aws_secretsmanager_secret_version.aqua_cspm_secret,
    time_sleep.sechub_integration_wait_10_aqua_cspm_secret,
  ]
}

resource "aws_lambda_invocation" "sechub_integration_onboarding" {
  function_name = module.sechub_integration_lambda.lambda_function_name
  input = jsonencode({
    ResourceProperties = {
      Enabled           = local.enable_security_hub_integration,
      Secret            = local.secret_name,
      RoleArn           = aws_iam_role.aqua_cspm_sechub.arn,
      ExtId             = local.sechub_external_id,
      AccId             = data.aws_caller_identity.current.account_id,
      Region            = data.aws_region.current.name,
      ScanNotifications = local.sechub_notification_type,
    },
    LogicalResourceId = "IntegrationInvoke"
  })

  depends_on = [
    time_sleep.sechub_integration_wait_10_seconds,
    aws_lambda_invocation.sechub_integration_external_id,
    aws_iam_role.aqua_cspm,
  ]
}

resource "time_sleep" "sechub_integration_wait_10_seconds" {
  depends_on = [
    aws_lambda_invocation.sechub_integration_external_id,
  ]

  create_duration = "10s"
}

resource "time_sleep" "sechub_integration_wait_10_aqua_cspm_secret" {
  depends_on = [
    aws_secretsmanager_secret_version.aqua_cspm_secret,
  ]

  create_duration = "10s"
}
