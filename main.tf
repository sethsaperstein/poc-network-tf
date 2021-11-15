terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "seth-saperstein"
    workspaces {
      name = "poc-network-tf"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "POC Network"
  }
}

resource "aws_subnet" "pub_sub" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pub_sub_cidr_block
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "prv_sub" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.prv_sub_cidr_block
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_route_table" "pub_sub_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public subnet route table"
  }
}

resource "aws_route_table_association" "internet_for_pub_sub" {
  route_table_id = aws_route_table.pub_sub_rt.id
  subnet_id      = aws_subnet.pub_sub.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "internet gateway"
  }
}

resource "aws_eip" "eip_natgw" {} 

resource "aws_nat_gateway" "natgateway" {
  allocation_id = aws_eip.eip_natgw.id
  subnet_id     = aws_subnet.pub_sub.id
}

resource "aws_route_table" "prv_sub_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway.id
  }
  tags = {
    Name = "private subnet route table"
  }
}
resource "aws_route_table_association" "prv_sub_to_natgw" {
  route_table_id = aws_route_table.prv_sub_rt.id
  subnet_id      = aws_subnet.prv_sub.id
}
