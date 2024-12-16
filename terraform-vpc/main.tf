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


resource "aws_vpc" "devops-aws" {
  cidr_block = "10.15.0.0/23"
  tags = {
    Name = "devops-aws"
  }
}
