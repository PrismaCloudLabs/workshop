output "ecrRepositoryURL" {
  value = aws_ecr_repository.pc-repo.repository_url
}

output "ecrRepositoryName" {
  value = aws_ecr_repository.pc-repo.name
}

output "iamInstanceProfileName" {
  value = aws_iam_instance_profile.ec2_ecr_profile.name
}