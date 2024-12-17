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

# ----------------- 1.0 Launch a Free-Tier EC2 Instance with existing public subnet & security group -----------------

resource "aws_instance" "free_tier_instance" {
  ami           = "ami-0775d166d9bde92c8"
  instance_type = "t2.micro"
  key_name      = "webserver-2-pem-key"
  subnet_id     = "subnet-07ff14f05f788821e"   # Add quotes around the subnet ID
  vpc_security_group_ids = ["sg-007f40e7061ce6220"] # Add quotes & use a list format of the Security group IDs

  tags = {
    Name = "server-with-existing-subnet-and-SG"
  }
}


