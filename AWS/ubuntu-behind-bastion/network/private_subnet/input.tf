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

variable "nat_gateway_ids" {
  type = "list"
}
