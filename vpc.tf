# Create a VPC to launch our instances into
resource "aws_vpc" "vpc-tf" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "vpc-tf"
  }
}

# Create two public subnets for EC2 instances etc
resource "aws_subnet" "pub_subnet_1" {
  vpc_id                  = aws_vpc.vpc-tf.id
  cidr_block              = var.pub_subnet_1_cidr
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "pub_subnet_2" {
  vpc_id                  = aws_vpc.vpc-tf.id
  cidr_block              = var.pub_subnet_2_cidr
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Public Subnet 2"
  }
}

# Create two private subnets for RDS instances etc (outgoing internet via NAT gateway only)
resource "aws_subnet" "priv_subnet_1" {
  vpc_id                  = aws_vpc.vpc-tf.id
  cidr_block              = var.priv_subnet_1_cidr
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "Private Subnet 1"
  }
}

resource "aws_subnet" "priv_subnet_2" {
  vpc_id                  = aws_vpc.vpc-tf.id
  cidr_block              = var.priv_subnet_2_cidr
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "Private Subnet 2"
  }
}
