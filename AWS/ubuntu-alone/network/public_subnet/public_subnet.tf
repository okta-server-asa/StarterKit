resource "aws_subnet" "public" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${element(var.cidrs, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  count             = "${length(var.cidrs)}"

  tags = {
    Name        = "${var.name}-subnet-${format("%03d", count.index+1)}"
    Environment = "${var.environment}"
    terraform   = true
    module      = "public_subnet"
  }

  lifecycle {
    create_before_destroy = true
  }

  map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.internet_gateway_id}"
  }

  tags = {
    Name        = "${var.name}-route-table"
    Environment = "${var.environment}"
    terraform   = true
    module      = "public_subnet"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.cidrs)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}
