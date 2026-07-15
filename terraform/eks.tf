##############################################
# EKS cluster
#
# Uses the official community EKS module — it handles the control plane,
# OIDC provider (needed for IAM Roles for Service Accounts), and the
# managed node group's launch template, autoscaling group, and IAM role.
# https://registry.terraform.io/modules/terraform-aws-modules/eks/aws
##############################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.project_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    instance_types = var.node_instance_types
  }

  eks_managed_node_groups = {
    default = {
      min_size     = var.node_min_size
      max_size     = var.node_max_size
      desired_size = var.node_desired_size

      instance_types = var.node_instance_types
      capacity_type  = "ON_DEMAND"
    }
  }

  # Lets your current AWS CLI user/role manage the cluster via kubectl
  enable_cluster_creator_admin_permissions = true
}
