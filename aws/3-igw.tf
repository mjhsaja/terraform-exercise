# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway

resource "aws_internet_gateway" "onxp-igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}