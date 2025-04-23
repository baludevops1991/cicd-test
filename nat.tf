resource "aws_eip" "nat" {
  depends_on = [aws_internet_gateway.igw]
  tags       = var.tags
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags          = var.tags
}
