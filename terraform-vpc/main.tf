# Configure the AWS Provider version 5.81.0

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ca-central-1"
}



# ----------------------------- 3.0 Define the VPC resource without Enabling DNS resolution &  DNS hostnames --------------------
## if you need to enable it, please add the following two lines under the cidr_block
## enable_dns_support   = true
## enable_dns_hostnames = true


resource "aws_vpc" "devops_aws" {
  cidr_block = "10.15.0.0/23"
  tags = {
    Name = "devops-aws"
  }
}


# ------------------ 4.0 Create public and private subnets: 4 subnets(2 public + 2 private) -------------------

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.devops_aws.id
  cidr_block              = "10.15.0.0/25"
  map_public_ip_on_launch = true
  availability_zone       = "ca-central-1a"
  tags = {
    Name = "PublicSubnet1-devops-aws"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.devops_aws.id
  cidr_block        = "10.15.0.128/25"
  availability_zone = "ca-central-1a"
  tags = {
    Name = "PrivateSubnet1-devops-aws"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.devops_aws.id
  cidr_block              = "10.15.1.0/25"
  map_public_ip_on_launch = true
  availability_zone       = "ca-central-1b"
  tags = {
    Name = "PublicSubnet2-devops-aws"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.devops_aws.id
  cidr_block        = "10.15.1.128/25"
  availability_zone = "ca-central-1b"
  tags = {
    Name = "PrivateSubnet2-devops-aws"
  }
}


# ------------- 5.0 Define an Internet Gateway: ---------------------

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.devops_aws.id
  tags = {
    Name = "InternetGateway-devops-aws"
  }
}


# ---------------------- 6.0 Create a Route Table for Public Subnets

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.devops_aws.id
  tags = {
    Name = "PublicRouteTable-devops-aws"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}


# --------- 7.0 Create a NAT Gateway for Private Subnets ------------

## 7.1 Elastic IP for NAT Gateway:

# resource "aws_eip" "nat_eip" {
#  vpc = true
# }

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}


## 7.2 NAT Gateway Resource:

resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = {
    Name = "NATGateway-devops-aws"
  }
}

## 7.3 Create a Route Table for Private Subnets

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.devops_aws.id
  tags = {
    Name = "PrivateRouteTable-devops-aws"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.my_nat_gateway.id
}

resource "aws_route_table_association" "private_subnet_association_1"   {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

# -------------------  




