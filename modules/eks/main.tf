# Create a Kubernetes Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name                      = "${var.name}-${var.environment}"
  version                   = var.cluster_version
  role_arn                  = aws_iam_role.eks_cluster_role.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  vpc_config {
    subnet_ids = concat(flatten(var.private_subnets_ids), flatten(var.public_subnets_ids))
  }
  timeouts {
    delete = "30m"
  }
  depends_on = [
    aws_cloudwatch_log_group.eks_cluster,
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy
  ]
  tags = {
    git_repo  = "sa-lab"
    yor_trace = "5f7ff6d4-a8ad-4172-9061-36015fdcf30e"
  }
}

resource "aws_iam_policy" "AmazonEKSClusterCloudWatchMetricsPolicy" {
  name   = "AmazonEKSClusterCloudWatchMetricsPolicy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "cloudwatch:PutMetricData"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
  tags = {
    git_repo  = "sa-lab"
    yor_trace = "184fcbcc-4035-4127-8949-9cb3886bcf15"
  }
}

resource "aws_iam_policy" "AmazonEKSClusterNLBPolicy" {
  name   = "AmazonEKSClusterNLBPolicy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "elasticloadbalancing:*",
                "ec2:CreateSecurityGroup",
                "ec2:Describe*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
  tags = {
    git_repo  = "sa-lab"
    yor_trace = "8f027d61-ae12-4dfd-9700-483a5d79b5a8"
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name                  = "${var.name}-eks-cluster-role"
  force_detach_policies = true

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "eks.amazonaws.com",
          "eks-fargate-pods.amazonaws.com"
          ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = {
    git_repo  = "sa-lab"
    yor_trace = "0db11b31-e248-470d-9df4-2ba99ff2414d"
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSCloudWatchMetricsPolicy" {
  policy_arn = aws_iam_policy.AmazonEKSClusterCloudWatchMetricsPolicy.arn
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSCluserNLBPolicy" {
  policy_arn = aws_iam_policy.AmazonEKSClusterNLBPolicy.arn
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_cloudwatch_log_group" "eks_cluster" {
  name              = "/aws/eks/${var.name}-${var.environment}/cluster"
  retention_in_days = 30

  tags = {
    Name        = "${var.name}-${var.environment}-eks-cloudwatch-log-group"
    Environment = var.environment
    git_repo    = "sa-lab"
    yor_trace   = "374728ba-afd2-4b47-b782-9543dd4b8d88"
  }
}