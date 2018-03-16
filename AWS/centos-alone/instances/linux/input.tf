variable "tagname" {
  type    = "string"
  default = "linux"
}

variable "environment" {
  type = "string"
}

variable "ami" {
  type = "string"
}

variable vpc_id {
  type = "string"
}

variable "userdata" {
  type    = "string"
  default = "echo 'No userdata supplied'"
}
