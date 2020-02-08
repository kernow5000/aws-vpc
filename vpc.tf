# Create a VPC to launch our instances into
resource "aws_vpc" "vpc-tf" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "vpc-tf"
  }
}

# Create public and private subnets

