data "aws_availability_zones" "available" {}

resource "aws_vpc" "prod" {
  cidr_block = var.vpc_cidr
  tags       = var.tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.prod.id
  tags   = var.tags
}
