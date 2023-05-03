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

variable "enable_security_hub_integration" {
  description = "Enables security hub integration with CSPM. Defaults to true"
  type        = bool
  default     = true
}

variable "sechub_notification_type" {
  description = "Select which findings to send to AWS security hub. Defaults to Send All Scan Reports"
  type        = string
  default     = "Send All Scan Reports"

  validation {
    condition     = contains(["Send All Scan Reports", "Send Only Failed Scan Reports"], var.sechub_notification_type)
    error_message = "sechub_notification_type must be either Send All Scan Reports or Send Only Failed Scan Reports"
  }
}
