module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "19.21.0"
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  vpc_id                          = var.vpc_id
  subnet_ids                      = length(var.subnet_ids) > 0 ? var.subnet_ids : var.private_subnet_ids
  cluster_endpoint_public_access  = true
  
  eks_managed_node_groups = var.eks_managed_node_groups
  
  # AWS auth configuration
  manage_aws_auth_configmap = true
  
  # Fix for the for_each error
  iam_role_use_name_prefix = false
  
  # Fix for the CNI policy issue
  eks_managed_node_group_defaults = {
    iam_role_attach_cni_policy = true
  }
  
  tags = var.tags
}
