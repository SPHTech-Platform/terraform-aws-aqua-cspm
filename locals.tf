locals {
  name_prefix = "aqua-cspm"

  secret_name = "/aquacspm/secret-cspm"

  external_id = "ds683bv"
  # external_id = local.lambda_extid["status"] == "FAILED" ? jsondecode(data.aws_lambda_invocation.external_id.result)["message"] : jsondecode(data.aws_lambda_invocation.external_id.result)["ExternalId"]
  # public_ip   = "13.215.18.141/32"

  aqua_cspm_role_policy_arns = [
    "arn:aws:iam::aws:policy/SecurityAudit",
    aws_iam_policy.aqua_cspm_supplemental.arn,
  ]
}
