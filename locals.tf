locals {
  name_prefix = "aqua-cspm"

  secret_name = "/aquacspm/secret-cspm"

  external_id = jsondecode(aws_lambda_invocation.external_id.result)["data"]
}
