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

variable "pubkey" {
  type = "string"

  # This is primarily here so the Azure API won't 400 Invalid Parameter us, so a default value is OK
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKejymSyHs8XU4CVnxRXsL7NZ70Y5b0xFu1mHQ7wRskjYcCZk1qbpUY8u8zQVmmVDOnsQTLFfvAGWDR15bv4X8bcqalcLXf7p2OSZRIGToCT3N50SmSYz2mXpESEuT25ymtE4HeMZqHyG+//+Meay1bAJZulKpu6veFWOCY3r+d107RVGO7dnJS6f2N88lZDR7Dy1PMbkgVHdoeczzsmIxZD4qsYuw2Xo0HyBA0V9VA5CMlxEotPmQt6ayDPeg5xEMzIwkt/VbyKAed8rIo3zslXqJVF1pm/lLsC1XJCE/ieuaunnz+GYiG7DtmIqmt7mk6k58UPINYQNBTkFIM0M7 fake@Fake"
}
