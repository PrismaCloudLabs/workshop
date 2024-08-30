output "vpcId" {
  value = module.network-hub.vpc_id
}

output "ecrRepositoryURL" {
  value = module.ecr.ecrRepositoryURL
}

output "ecrRepositoryName" {
  value = module.ecr.ecrRepositoryName
}

output "eksClusterName" {
  value = var.eks_cluster_name
}

output "eksPublicSubnets" {
  value = join(",", flatten([module.network-hub.public_subnet_id]))
}

output "publicIPs" {
  value = module.vmhosts.publicIPs
}

output "securityGroupIds" {
  value = module.vmhosts.securityGroupIds
}