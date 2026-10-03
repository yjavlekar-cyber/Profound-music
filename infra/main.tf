data "aws_availability_zones" "available" {}

data "aws_eks_cluster_auth" "cluster" {
    name = module.aws_eks_cluster.cluster_name
}

module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "~> 5.0"

    name = "${var.cluster_name}-vpc"
    cidr = "10.0.0.0/16"

    azs             = slice(data.aws_availability_zones.available.names, 0, 3)
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

    enable_nat_gateway = true
    single_nat_gateway = true
    enable_dns_hostnames = true

    public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
    }
}


module "aws_eks_cluster" {
    source  = "terraform-aws-modules/eks/aws"
    version = "~> 20.0"

    cluster_name    = var.cluster_name
    cluster_version = "1.31"

    cluster_endpoint_public_access = true

    vpc_id                   = module.vpc.vpc_id
    subnet_ids               = module.vpc.private_subnets
   
    enable_cluster_creator_admin_permissions = true


    cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }


    eks_managed_node_groups = {
        default_nodes = {
            name = "worker-nodes"
            instance_types = ["t3.medium"]

            min_size = 1
            max_size = 3
            desired_size = 2

            iam_role_additional_policies = {
                AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        }
    }
 }
}