variable "name" {
  type        = "string"
  description = "Name of the Network Stack"
}

variable "environment" {
  type = "string"
}

variable "availability_zones" {
  type = "list"
}

variable "public_cidrs" {
  type = "list"
}
