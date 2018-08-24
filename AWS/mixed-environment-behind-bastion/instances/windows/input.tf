variable "tagname" {
  type    = "string"
  default = "win"
}

variable "environment" {
  type = "string"
}

variable vpc_id {
  type = "string"
}

variable "ami" {
  type = "string"
}

variable "userdata" {
  type    = "string"
  default = "Write-Output 'No userdata set'\r\n"
}
