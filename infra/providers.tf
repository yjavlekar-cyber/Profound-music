terraform {
    required_version = ">=1.5.0"

        required_providers {
            aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0" # Locks to the major version 5 to prevent breaking updates
        }
        kubernetes = {
        source  = "hashicorp/kubernetes"
        version = "~> 2.0"
        }
        helm = {
        source  = "hashicorp/helm"
        version = "~> 2.0"
        }

        # Optional: Configure where to save your state file. 
    # Uncomment this once you have an S3 bucket ready for remote state management.
    # backend "s3" {
    #   bucket         = "your-terraform-state-bucket"
    #   key            = "eks/terraform.tfstate"
    #   region         = "us-east-1"
    #   dynamodb_table = "terraform-locks"
    # }

  }
}
provider "aws" {
    region = var.aws_region #this value will be picked from variables tf

    default_tags {
        tags = {
            Environment = var.env
            Project = "Profound-music-website"
            ManagedBy = "Profound"

        }
    }
}

provider "kubernetes" {
  host                   = module.aws_eks_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
provider "helm" {
  kubernetes {
    host                   = module.aws_eks_cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}