locals {
  name_prefix = "aqua-cspm"

  secret_name = "/aquacspm/secret-cspm"

  external_id        = jsondecode(aws_lambda_invocation.external_id.result)["status"] == "FAILED" ? jsondecode(aws_lambda_invocation.external_id.result)["message"] : jsondecode(aws_lambda_invocation.external_id.result)["ExternalId"]
  sechub_external_id = jsondecode(aws_lambda_invocation.sechub_integration_external_id[0].result)["status"] == "FAILED" ? jsondecode(aws_lambda_invocation.sechub_integration_external_id[0].result)["message"] : jsondecode(aws_lambda_invocation.sechub_integration_external_id[0].result)["ExternalId"]

  aquasec_account_id = "057012691312"
  # public_ip   = "13.215.18.141/32"

  aqua_cspm_role_policy_arns = [
    "arn:aws:iam::aws:policy/SecurityAudit",
    aws_iam_policy.aqua_cspm_supplemental.arn,
  ]
}
