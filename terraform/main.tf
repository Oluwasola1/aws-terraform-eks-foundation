##############################################
# Terraform + Provider configuration
##############################################

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # --- Remote state (stretch goal) ---
  # Once you've created an S3 bucket + DynamoDB table for state locking,
  # uncomment this block and run `terraform init` again to migrate state.
  #
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket-name"
  #   key            = "eks-foundation/terraform.tfstate"
  #   region         = "eu-central-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "aws-terraform-eks-foundation"
      ManagedBy   = "terraform"
      Environment = var.environment
    }
  }
}
