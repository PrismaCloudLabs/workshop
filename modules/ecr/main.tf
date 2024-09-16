resource "random_string" "this" {
  lower   = true
  upper   = false
  special = false
  length  = 6
}


resource "aws_ecr_repository" "pc-repo" {
  name                 = "${lower(var.ecr_name)}-${random_string.this.id}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  tags = {}
}

resource "aws_iam_policy" "ecr_access" {
  name        = "ecr_access_policy_${random_string.this.id}"
  description = "Policy to allow EC2 instances to access ECR and S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:GetAuthorizationToken",
        ],
        Resource = "*",
      },
      {
        Effect = "Allow",
        Action = [
          "s3:*"
        ],
        Resource = [
          "${var.s3_arn}",
          "arn:aws:s3:::*/object/*"
        ]
      }
    ],
  })
  tags = {}
}

resource "aws_iam_role" "ec2_ecr_role" {
  name = "ec2_pclab_role_${random_string.this.id}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com",
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
  tags = {}
}

resource "aws_iam_instance_profile" "ec2_ecr_profile" {
  name = "ec2_ecr_instance_profile_${random_string.this.id}"
  role = aws_iam_role.ec2_ecr_role.name
  tags = {}
}

resource "aws_iam_role_policy_attachment" "ec2-ecr" {
  role       = aws_iam_role.ec2_ecr_role.name
  policy_arn = aws_iam_policy.ecr_access.arn
}