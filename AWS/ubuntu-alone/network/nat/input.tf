variable "name" {
  default = "nat"
}

variable "environment" {
  type = "string"
}

variable "availability_zones" {
  type = "list"
}

variable "subnet_ids" {
  type = "list"
}
