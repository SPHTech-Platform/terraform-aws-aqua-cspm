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

variable "stack_name" {
  description = "Stack Name"
  type        = string
  default     = "aquasec"
}

variable "tags" {
  description = "A map of tags to add to all resources"\
  type = map(string)
  default = {}
}
