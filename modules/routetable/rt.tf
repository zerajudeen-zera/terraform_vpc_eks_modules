resource "aws_route_table" "this" {
  vpc_id = var.vpc_id
}

resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"

  gateway_id     = var.igw_id
  nat_gateway_id = var.nat_gateway_id
}