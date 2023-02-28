output "onboarding_data" {
  description = "Details of the onboarding"
  value       = jsondecode(aws_lambda_invocation.onboarding.result)
}
