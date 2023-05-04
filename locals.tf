locals {
  name_prefix = "aqua-cspm"

  secret_name = "/aquacspm/secret-cspm"

  external_id        = jsondecode(aws_lambda_invocation.external_id.result)["status"] == "FAILED" ? jsondecode(aws_lambda_invocation.external_id.result)["message"] : jsondecode(aws_lambda_invocation.external_id.result)["ExternalId"]
  sechub_external_id = try(jsondecode(aws_lambda_invocation.sechub_integration_external_id.result)["status"] == "FAILED" ? jsondecode(aws_lambda_invocation.sechub_integration_external_id.result)["message"] : jsondecode(aws_lambda_invocation.sechub_integration_external_id.result)["ExternalId"], "")

  aquasec_account_id = "057012691312"
  # public_ip   = "13.215.18.141/32"

  enable_security_hub_integration = var.aqua_sechub_integration.enabled
  notification_type = {
    send_all         = "Send All Scan Reports"
    send_only_failed = "Send Only Failed Scan Reports"
  }
  sechub_notification_type = lookup(local.notification_type, var.aqua_sechub_integration.notification_type)

  aqua_cspm_role_policy_arns = [
    "arn:aws:iam::aws:policy/SecurityAudit",
    aws_iam_policy.aqua_cspm_supplemental.arn,
  ]
}
