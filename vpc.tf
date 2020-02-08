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

resource "aws_internet_gateway" "vpc-tf-igw" {
  vpc_id = aws_vpc.vpc-tf.id

  tags = {
    Name = "vpc-tf-igw"
  }
}

# Create an Elastic IP for Gateway
resource "aws_eip" "vpc-tf-ngw-eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.vpc-tf-igw]
}

# Create a NAT Gateway
resource "aws_nat_gateway" "vpc-tf-ngw" {
  allocation_id = aws_eip.vpc-tf-ngw-eip.id
  subnet_id     = aws_subnet.pub_subnet_1.id
  depends_on    = [aws_internet_gateway.vpc-tf-igw]
}

# Grant the VPC internet access on its main route table
# Don't quite understand this bit, why not just for public subnets 
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.vpc-tf.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc-tf-igw.id
}

# Create routing tables for public and private subnets
resource "aws_route_table" "pub_subnet_1_routetable" {
  vpc_id = aws_vpc.vpc-tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-tf-igw.id
  }

  tags = {
    Name = "Public Subnet 1 route table"
  }
}

resource "aws_route_table" "pub_subnet_2_routetable" {
  vpc_id = aws_vpc.vpc-tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-tf-igw.id
  }

  tags = {
    Name = "Public Subnet 2 route table"
  }
}

resource "aws_route_table" "priv_subnet_1_routetable" {
  vpc_id = aws_vpc.vpc-tf.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.vpc-tf-ngw.id
  }

  tags = {
    Name = "Private Subnet 1 route table"
  }
}

resource "aws_route_table" "priv_subnet_2_routetable" {
  vpc_id = aws_vpc.vpc-tf.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.vpc-tf-ngw.id
  }

  tags = {
    Name = "Private Subnet 2 route table"
  }
}

# Associate routing tables with subnets
resource "aws_route_table_association" "pub_subnet_1_routetable_association" {
  subnet_id      = aws_subnet.pub_subnet_1.id
  route_table_id = aws_route_table.pub_subnet_1_routetable.id
}

resource "aws_route_table_association" "pub_subnet_2_routetable_association" {
  subnet_id      = aws_subnet.pub_subnet_2.id
  route_table_id = aws_route_table.pub_subnet_2_routetable.id
}

resource "aws_route_table_association" "priv_subnet_1_routetable_association" {
  subnet_id      = aws_subnet.priv_subnet_1.id
  route_table_id = aws_route_table.priv_subnet_1_routetable.id
}

resource "aws_route_table_association" "priv_subnet_2_routetable_association" {
  subnet_id      = aws_subnet.priv_subnet_2.id
  route_table_id = aws_route_table.priv_subnet_2_routetable.id
}

