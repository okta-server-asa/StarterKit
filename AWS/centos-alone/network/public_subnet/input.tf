variable "name" {
  type = "string"
}

variable "environment" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "cidrs" {
  type = "list"
}

variable "availability_zones" {
  type = "list"
}

variable "internet_gateway_id" {
  type = "string"
}
