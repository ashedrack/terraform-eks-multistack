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
  cluster_name        = "dev-eks"
  cluster_version     = var.eks_version
  private_subnet_ids  = module.network.private_subnet_ids
  vpc_id              = module.network.vpc_id
  tags                = var.tags
  depends_on          = [module.network]
}

module "iam" {
  source = "../../modules/iam"
  name   = "dev"
  tags   = var.tags
}

