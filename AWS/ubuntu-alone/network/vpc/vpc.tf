resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.name}-vpc"
    Environment = "${var.environment}"
    terraform   = true
    module      = "vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name        = "${var.name}-gateway"
    Environment = "${var.environment}"
    terraform   = true
    module      = "vpc"
  }
}

data "aws_region" "current" {
}

resource "aws_vpc_dhcp_options" "main" {
  domain_name = "${data.aws_region.current.name}.compute.internal"

  domain_name_servers = [
    "AmazonProvidedDNS",
  ]

  tags = {
    Name        = "${var.name}-dhcp-options"
    Environment = "${var.environment}"
    terraform   = true
    module      = "vpc"
  }
}

resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = "${aws_vpc.main.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.main.id}"
}
