module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 1.5.0"

  description = "KMS Key Id used to encrypt/decrypt the Secret"
  key_usage   = "ENCRYPT_DECRYPT"

  policy = data.aws_iam_policy_document.aqua_cspm_control_tower_kms_key.json

  aliases = [
    "alias/AquaCSPM-Control-Tower-${local.stack_name}",
  ]

  tags = var.tags
}
