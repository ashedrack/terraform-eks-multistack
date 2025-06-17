// Example main.tf for dev environment

module "network" {
  source          = "../../modules/network"
  name            = "dev"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
  tags            = var.tags
}

module "eks" {
  source              = "../../modules/eks"
  cluster_name        = "my-eks-cluster"  # Changed to match the name expected in CI/CD workflow
  cluster_version     = var.eks_version
  private_subnet_ids  = module.network.private_subnet_ids
  vpc_id              = module.network.vpc_id
  managed_node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t3.medium"
    }
  }
  tags                = var.tags
  depends_on          = [module.network]
}

module "iam" {
  source = "../../modules/iam"
  name   = "dev"
  tags   = var.tags
}

# Add RDS PostgreSQL database
module "rds" {
  source                 = "../../modules/rds"
  allocated_storage      = 20
  engine_version         = "15.3"
  instance_class         = "db.t3.micro"
  db_name                = "appdb"
  db_username            = "dbadmin"
  db_password            = "ChangeMe123!" # In production, use AWS Secrets Manager
  db_subnet_group_name   = module.network.database_subnet_group_name
  vpc_security_group_ids = [module.network.database_security_group_id]
  name                   = "dev"
  tags                   = var.tags
  depends_on             = [module.network]
}

