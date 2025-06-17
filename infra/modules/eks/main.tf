module "eks" {
  source              = "terraform-aws-modules/eks/aws"
  version             = "19.21.0"
  cluster_name        = var.cluster_name
  cluster_version     = var.cluster_version
  subnets             = var.private_subnet_ids
  vpc_id              = var.vpc_id
  tags                = var.tags
  managed_node_groups = var.managed_node_groups
  manage_aws_auth     = true
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "kubeconfig" {
  value = module.eks.kubeconfig
}

output "node_group_role_arn" {
  value = try(module.eks.managed_node_groups["default"].iam_role_arn, null)
}
