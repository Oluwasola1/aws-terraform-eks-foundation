##############################################
# Networking layer
#
# Uses the official community VPC module instead of hand-rolling every
# subnet/route-table resource — this is what's used in real-world
# Terraform codebases. Read through the module source on the Terraform
# Registry to see what it creates under the hood:
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws
##############################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  enable_nat_gateway   = true
  single_nat_gateway   = true # one shared NAT gateway to keep costs down for a portfolio project
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Tags EKS needs to auto-discover subnets for load balancers and nodes
  public_subnet_tags = {
    "kubernetes.io/role/elb"                      = "1"
    "kubernetes.io/cluster/${var.project_name}"   = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"             = "1"
    "kubernetes.io/cluster/${var.project_name}"   = "shared"
  }
}
