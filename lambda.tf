module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.10.1"

  function_name = "${local.name_prefix}-function"
  description   = "Retrieves the External ID from Aqua CSPM"
  handler       = "index.lambda_handler"
  runtime       = "python3.7"

  memory_size = 128
  timeout     = 30

  create_package         = false
  local_existing_package = "${path.module}/src/lambda_function/lambda_function.zip"
  #   source_path = "${path.module}/src/lambda_function"

  lambda_role = module.lambda_role.iam_role_arn

  tags = var.tags
}

resource "aws_lambda_invocation" "external_id" {
  function_name = module.lambda.lambda_function_name
  input = jsonencode({
    ResourceProperties = {
      Secret = aws_secretsmanager_secret.aqua_cspm_secret.id
    },
    LogicalResourceId = "ExternalIDInvoke"
  })
}

resource "aws_lambda_invocation" "onboarding" {
  function_name = module.lambda.lambda_function_name
  input = jsonencode({
    ResourceProperties = {
      Secret  = aws_secretsmanager_secret.aqua_cspm_secret.id,
      ExtId   = local.external_id,
      Group   = var.aqua_group_name,
      RoleArn = aws_iam_role.aqua_cspm.arn,
      AccId   = data.aws_caller_identity.current.account_id
    },
    LogicalResourceId = "OnboardingInvoke"
  })
}
