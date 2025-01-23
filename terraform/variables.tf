variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "app_name" {
  type    = string
  default = "ephemeral-security-testing"
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}