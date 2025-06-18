# Create IAM roles separately to avoid for_each issues
resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role" "node_group" {
  name = "${var.cluster_name}-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_group.name
}

module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "19.21.0"
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  vpc_id                          = var.vpc_id
  subnet_ids                      = length(var.subnet_ids) > 0 ? var.subnet_ids : var.private_subnet_ids
  cluster_endpoint_public_access  = true
  
  # Use our pre-created IAM roles
  create_iam_role = false
  iam_role_arn    = aws_iam_role.cluster.arn
  
  eks_managed_node_groups = {
    default = {
      min_size     = lookup(var.eks_managed_node_groups.default, "min_size", 1)
      max_size     = lookup(var.eks_managed_node_groups.default, "max_size", 3)
      desired_size = lookup(var.eks_managed_node_groups.default, "desired_size", 2)
      instance_types = lookup(var.eks_managed_node_groups.default, "instance_types", ["t3.medium"])
      
      # Use our pre-created IAM role
      create_iam_role = false
      iam_role_arn    = aws_iam_role.node_group.arn
    }
  }
  
  # AWS auth configuration
  manage_aws_auth_configmap = true
  
  # Disable features that use for_each with computed values
  create_cloudwatch_log_group = false
  
  tags = var.tags
}
