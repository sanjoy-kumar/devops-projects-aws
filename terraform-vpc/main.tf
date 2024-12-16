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



# Define the VPC resource without Enabling DNS resolution &  DNS hostnames 
# if you need to enable it, please add the following two lines under the cidr_block
# enable_dns_support   = true
# enable_dns_hostnames = true


resource "aws_vpc" "devops_aws" {
  cidr_block = "10.15.0.0/23"
  tags = {
    Name = "devops-aws"
  }
}


# Create public and private subnets: 4 subnets(2 public + 2 private)

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


