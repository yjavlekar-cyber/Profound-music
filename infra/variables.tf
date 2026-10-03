variable "aws_region" {
    description = "The aws region where resources will be created"
    type = string
    default = "us-east-1"
}

variable "env" {
    description = "The deployment environment name"
    type = string
    default = "Prod"
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "Profoundmusic-cluster"
}

