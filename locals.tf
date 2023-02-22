locals {
  name_prefix = "aqua-cspm"

  secret_name = "/aquacspm/secret-cspm"

  external_id = jsondecode(aws_lambda_invocation.external_id.result)["data"]["ExternalId"]
  public_ip   = "3.231.74.65/32"

  aqua_cspm_role_policy_arns = [
    "arn:aws:iam::aws:policy/SecurityAudit",
    aws_iam_policy.aqua_cspm_supplemental.arn,
  ]
}
