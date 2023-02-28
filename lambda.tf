module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.10.1"

  function_name = "${local.name_prefix}-function"
  description   = "Retrieves the External ID from Aqua CSPM"
  handler       = "index.lambda_handler"
  runtime       = "python3.9"

  memory_size = 128
  timeout     = 30

  create_package         = false
  local_existing_package = "${path.module}/src/lambda_function/lambda_function.zip"

  create_role = false
  lambda_role = module.lambda_role.iam_role_arn

  tags = var.tags
}

# resource "aws_lambda_invocation" "external_id" {
#   function_name = module.lambda.lambda_function_name
#   input = jsonencode({
#     ResourceProperties = {
#       Secret = local.secret_name
#     },
#     LogicalResourceId = "ExternalIDInvoke"
#   })

#   depends_on = [
#     aws_secretsmanager_secret_version.aqua_cspm_secret,
#   ]
# }

resource "aws_lambda_invocation" "onboarding" {
  function_name = module.lambda.lambda_function_name
  input = jsonencode({
    ResourceProperties = {
      Secret  = local.secret_name,
      ExtId   = local.external_id,
      Group   = var.aqua_group_name,
      RoleArn = aws_iam_role.aqua_cspm.arn,
      AccId   = data.aws_caller_identity.current.account_id
    },
    LogicalResourceId = "OnboardingInvoke"
  })

  depends_on = [
    time_sleep.wait_10_seconds,
    aws_lambda_invocation.external_id,
    aws_iam_role.aqua_cspm,
  ]
}

resource "time_sleep" "wait_10_seconds" {
  depends_on = [
    aws_lambda_invocation.external_id,
  ]

  create_duration = "10s"
}
