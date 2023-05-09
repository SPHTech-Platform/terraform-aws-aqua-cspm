variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "aqua_cspm_apikey" {
  description = "Aqua CSPM API key: Account Management > API Keys > Generate Key"
  type        = string
  sensitive   = true
}

variable "aqua_cspm_secretkey" {
  description = "Aqua CSPM Secret"
  type        = string
  sensitive   = true
}

variable "aqua_group_name" {
  description = "Aqua CSPM Group Name from the Aqua Wave console"
  type        = string
  default     = "Default"
}

#########
## KMS ##
#########
variable "kms_aliases" {
  description = "A list of aliases to create. Note - due to the use of toset(), values must be static strings and not computed values"
  type        = list(string)
  default = [
    "alias/AquaCSPM-Control-Tower-AquaSec"
  ]
}

variable "enable_kms_key_rotation" {
  description = "Specifies whether key rotation is enabled. Defaults to true"
  type        = bool
  default     = true
}

#############################
# Security Hub integration
#############################
variable "aqua_sechub_integration" {
  description = <<-EOF
    Enables aqua security hub integration. If enabled, findings from Aquasec will be pushed to security hub.
    Notification type can be either "send_all" or "send_only_failed". Default is "send_all"
    EOF
  type = object({
    enabled           = bool
    notification_type = optional(string, "send_all")
  })
  default = {
    enabled = false
  }

  validation {
    condition     = contains(["send_all", "send_only_failed"], var.aqua_sechub_integration.notification_type)
    error_message = "sechub_notification_type must be either Send All Scan Reports (send_all) or Send Only Failed Scan Reports (send_only_failed)"
  }
}
