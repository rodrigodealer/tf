variable "lb_name" {}

variable "region" {}

variable "instance_port" {}

variable "lb_port" {}

variable "healthy_threshold" {
  default = 2
}

variable "unhealthy_threshold" {
  default = 2
}

variable "timeout" {
  default = 3
}

variable "interval" {
  default = 10
}

variable "target" {
}

variable "instances" {
}

variable "subnet_id" {
}

variable "security_groups" {
}