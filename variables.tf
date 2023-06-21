variable "region" {
  description = "List of Allowed AWS account IDs"
  type        = string
}

variable "account_id" {
  description = "Allowed AWS account IDs"
  type        = list(string)
}

variable "prefix" {
  description = "prefix for aws resources and tags"
  type        = string
}

variable "tags" {
  description = "tag map"
  type        = map(string)
}

variable "create_ram" {
  description = "Controls if Resource Access Manager should be created (it affects almost all resources)"
  type        = bool
  default     = false
}

variable "ram_name" {
  description = "The name of the resource share"
  type        = string
  default     = ""
}

variable "allow_external_principals" {
  description = "Indicates whether principals outside your organization can be associated with a resource share"
  type        = bool
  default     = false
}

variable "resource_arn" {
  description = "Amazon Resource Name (ARN) of the resource to associate with the RAM Resource Share"
  type        = string
  default     = ""
}

variable "ram_principals" {
  description = "The principal to associate with the resource share. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN"
  type        = list(string)
  default     = []
}

variable "share_accepter" {
  description = "Controls if Resource Access Manager resource share accepter should be created (it affects almost all resources)"
  type        = bool
  default     = false
}

variable "ram_resource_share_arn" {
  description = "The ARN of the resource share"
  type        = string
  default     = ""
}