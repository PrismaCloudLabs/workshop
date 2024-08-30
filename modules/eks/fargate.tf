#Fargate configuration
resource "aws_iam_role" "eks-fargate-profile" {
  name = "eks-fargate-profile"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  tags = {
    git_repo  = "sa-lab"
    yor_trace = "33a91417-05d7-4af1-9122-5d404c282df1"
  }
}

resource "aws_iam_role_policy_attachment" "eks-fargate-profile" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks-fargate-profile.name
}

resource "aws_eks_fargate_profile" "namespace" {
  count                  = length(var.namespaces)
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = var.namespaces[count.index]
  pod_execution_role_arn = aws_iam_role.eks-fargate-profile.arn
  subnet_ids             = var.private_subnets_ids[0]

  selector {
    namespace = var.namespaces[count.index]
  }
  tags = {
    git_repo  = "sa-lab"
    yor_trace = "4ad87520-1f83-4f9f-b065-f021ed555c6a"
  }
}