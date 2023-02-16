module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 1.5.0"

  description = "KMS Key Id used to encrypt/decrypt the Secret"
  key_usage   = "ENCRYPT_DECRYPT"

  policy = data.aws_iam_policy_document.aqua_cspm_control_tower_kms_key.json

  aliases = var.kms_aliases

  enable_key_rotation = var.enable_kms_key_roration

  tags = var.tags
}
