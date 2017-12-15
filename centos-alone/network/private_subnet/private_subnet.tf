resource "aws_subnet" "private" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${element(var.cidrs, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  count             = "${length(var.cidrs)}"

  tags {
    Name        = "${var.name}-subnet-${format("%03d", count.index+1)}"
    Environment = "${var.environment}"
    terraform   = true
    module      = "private_subnet"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(var.nat_gateway_ids, count.index)}"
  }

  tags {
    Name        = "${var.name}-route-table"
    Environment = "${var.environment}"
    terraform   = true
    module      = "private_subnet"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.cidrs)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"

  lifecycle {
    create_before_destroy = true
  }
}
