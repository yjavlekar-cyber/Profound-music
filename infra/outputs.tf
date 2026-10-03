output "cluster_endpoint" {
  description = "The HTTP endpoint for your EKS Kubernetes API server."
  value       = module.aws_eks_cluster.cluster_endpoint
}

output "cluster_name" {
  description = "The generated name of the EKS cluster."
  value       = module.aws_eks_cluster.cluster_name
}

output "vpc_id" {
  description = "The ID of the generated VPC."
  value       = module.vpc.vpc_id
}

output "connect_kubectl_command" {
  description = "Run this exact command in your terminal to connect kubectl to your new cluster."
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.aws_eks_cluster.cluster_name}"
}
