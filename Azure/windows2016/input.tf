variable "subscription_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "tenant_id" {}

variable "location" {
  type    = "string"
  default = "eastus"
}

variable "name" {
  type    = "string"
  default = "scaleft-demo"
}

variable "environment" {
  type    = "string"
  default = "demo"
}

variable "sftd_version" {
  type    = "string"
  default = "1.50.3"
}

variable "enrollment_token" {
  type = "string"
}

variable "admin_password" {
  type = "string"
}
