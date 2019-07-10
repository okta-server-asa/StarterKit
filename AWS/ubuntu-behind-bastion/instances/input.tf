variable name {
  type = "string"
}

variable environment {
  type = "string"
}

variable vpc_id {
  type = "string"
}

variable subnet {
  type = list(any)
}

variable sftd_version {
  type = "string"
}

variable enrollment_token {
  type = "string"
}
