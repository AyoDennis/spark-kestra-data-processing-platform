# Provisioning the VPC where EMR will be deployed
resource "aws_vpc" "emr-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name        = "custom-vpc"
    environment = "production"
    owner       = "data_platform_team"
    managed_by  = "terraform"
  }
}

# Creating public subnet 1
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.emr-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

# Creating public subnet 2
resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.emr-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }
}


# Creating internet gateway and attaching to VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.emr-vpc.id

  tags = {
    Name = "custom-igw"
  }
}

# Creating route table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.emr-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Making explicit association of public subnet 1 to route table
resource "aws_route_table_association" "public-subnet-association-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-rt.id
}

# Making explicit association of public subnet 2 to route table
resource "aws_route_table_association" "public-subnet-association-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-rt.id
}
