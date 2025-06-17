variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}

variable "managed_node_groups" {
  description = "Map of EKS managed node group definitions to forward to the upstream module."
  type        = any
  default     = {}
}


variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
