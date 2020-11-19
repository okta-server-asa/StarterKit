variable "secret_key" {
}

variable "access_key" {
}

provider "aws" {
  region     = "us-west-2"
  secret_key = var.secret_key
  access_key = var.access_key
}

variable "name" {
  type    = string
  default = "scaleft-demo"
}

variable "environment" {
  type    = string
  default = "demo"
}

variable "sftd_version" {
  type    = string
  default = "1.50.3"
}

variable "windows_canonical_name" {
  type    = string
  default = "win-target"
}

variable "enrollment_token" {
  type = string
}

// Path to key used to decrypt Administrator pw in the AWS console
variable "aws_key_path" {
  type        = string
  default     = "~/.ssh/windeployer-rsa.pub"
  description = "Used to decrypt administrator passwords in the AWS console"
}

