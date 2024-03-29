resource "aws_secretsmanager_secret" "aqua_cspm_secret" {
  #checkov:skip=CKV2_AWS_57
  description = "Secret that contains Aqua CSPM API URL and token"
  name        = local.secret_name
  kms_key_id  = module.kms.key_arn
}

resource "aws_secretsmanager_secret_version" "aqua_cspm_secret" {
  secret_id = aws_secretsmanager_secret.aqua_cspm_secret.id

  secret_string = jsonencode({
    aqua_api_key = var.aqua_cspm_apikey
    aqua_secret  = var.aqua_cspm_secretkey
  })
}

resource "aws_secretsmanager_secret_policy" "aqua_cspm_secret" {
  secret_arn = aws_secretsmanager_secret.aqua_cspm_secret.arn
  policy     = data.aws_iam_policy_document.aqua_cspm_secret.json
}
