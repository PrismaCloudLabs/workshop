output "cluster_name" {
  value       = aws_eks_cluster.eks_cluster.name
  description = "Name of the cluster created"
}

output "cluster_version" {
  value       = aws_eks_cluster.eks_cluster.version
  description = "Kubernetes Cluster version"
}

output "endpoint" {
  value       = aws_eks_cluster.eks_cluster.endpoint
  description = "Access endpoint"
}

output "id" {
  value       = aws_eks_cluster.eks_cluster.id
  description = "Id of the EKS Cluster"
}

output "oidc_provider_url" {
  value = aws_iam_openid_connect_provider.oidc_provider.url
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.oidc_provider.arn
}