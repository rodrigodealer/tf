variable "additional_ips_count" {
  type        = number
  description = "Count of additional EIPs"
  default     = 0
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address with the instance"
  default     = true
}

variable "instance_enabled" {
  type        = bool
  description = "Flag to control the instance creation. Set to false if it is necessary to skip instance creation"
  default     = true
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "security_group_ids" {
}

variable "instance_id" {}