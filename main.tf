module "vpc" {
    source = "./modules/vpc"
    cidr_block = var.vpc_cidr_block
    name_vpc = var.name_vpc_tag
  
}


module "igw-vpc" {
    source = "./modules/igw"
    vpc_id = module.vpc.vpc_id
    igwname = var.ig-name
  
}

module "nat_gateway" {
  source = "./modules/nat"

  public_subnet_id = module.public_subnets[0].subnet_id
}

module "public_route_table" {
  source = "./modules/routetable"
  vpc_id = module.vpc.vpc_id
  igw_id = module.igw-vpc.igw-id
}

module "public_rt_assoc" {
  source = "./modules/routeassociation"
  count  = length(module.public_subnets)

  subnet_id      = module.public_subnets[count.index].subnet_id
  route_table_id = module.public_route_table.route_table_id
}

module "private_route_table" {
  source = "./modules/routetable"

  vpc_id           = module.vpc.vpc_id
  nat_gateway_id   = module.nat_gateway.nat_gateway_id
}

module "private_rt_assoc" {
  source = "./modules/routeassociation"
  count  = length(module.private_subnets)

  subnet_id      = module.private_subnets[count.index].subnet_id
  route_table_id = module.private_route_table.route_table_id
}

module "public_subnets" {
  source = "./modules/subnets"
  count  = 2

  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.public_subnet_cidrs[count.index]
  az                      = var.azs[count.index]
  map_public_ip_on_launch = true
  name                    = "public-subnet-${count.index + 1}"
}

module "private_subnets" {
  source = "./modules/subnets"
  count  = 2

  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.private_subnet_cidrs[count.index]
  az                      = var.azs[count.index]
  map_public_ip_on_launch = false
  name                    = "private-subnet-${count.index + 1}"
}

module "eks_cluster_role" {
  source = "./modules/iam-eks-cluster"
}

module "eks_node_role" {
  source = "./modules/iam-eks-node"
}

module "eks" {
  source = "./modules/eks"

  cluster_name        = "my-eks-cluster"
  kubernetes_version  = "1.29"
  cluster_role_arn    = module.eks_cluster_role.role_arn
  subnet_ids          = [for s in module.private_subnets : s.subnet_id]

  cluster_role_depends_on = [
    module.eks_cluster_role
  ]
}

module "eks_node_group" {
  source = "./modules/eks-node-group"

  cluster_name    = module.eks.cluster_name
  node_group_name = "private-nodes"
  node_role_arn   = module.eks_node_role.role_arn
  subnet_ids      = [for s in module.private_subnets : s.subnet_id]
}
