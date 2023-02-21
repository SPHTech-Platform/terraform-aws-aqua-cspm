output "onboarding_data" {
  description = "Details of the onboarding"
  value       = jsondecode(data.aws_lambda_invocation.onboarding.result)["data"]
}
