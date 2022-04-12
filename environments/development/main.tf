terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.9.0"
    }
  }

  backend "s3" {}
}

locals {
  tags = {
    Project     = var.project
    Environment = var.environment
    Owner       = var.owner
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = local.tags
  }
}
