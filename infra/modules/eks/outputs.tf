output "cluster_name" {
  value = module.eks.cluster_name
}

output "kubeconfig" {
  description = "Generated kubeconfig for the EKS cluster"
  value = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  }
  sensitive = true
}

output "node_group_role_arn" {
  value = try(module.eks.eks_managed_node_groups["default"].iam_role_arn, null)
}
