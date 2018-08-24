resource "aws_eip" "nat" {
  vpc   = true
  count = "${length(var.availability_zones)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(var.subnet_ids, count.index)}"
  count         = "${length(var.availability_zones)}"

  tags {
    Name        = "${var.name}-natgw"
    Environment = "${var.environment}"
    terraform   = true
    module      = "nat"
  }

  lifecycle {
    create_before_destroy = true
  }
}
