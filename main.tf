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

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "internet gateway"
  }
}

module "subnets_1" {
  source = "./modules/az_subnets"

  vpc_id             = aws_vpc.main.id
  az                 = var.az_1
  pub_sub_cidr_block = var.pub_sub_cidr_block_1
  prv_sub_cidr_block = var.prv_sub_cidr_block_1
  internet_gw_id     = aws_internet_gateway.igw.id
}

module "subnets_2" {
  source = "./modules/az_subnets"

  vpc_id             = aws_vpc.main.id
  az                 = var.az_2
  pub_sub_cidr_block = var.pub_sub_cidr_block_2
  prv_sub_cidr_block = var.prv_sub_cidr_block_2
  internet_gw_id     = aws_internet_gateway.igw.id
}
