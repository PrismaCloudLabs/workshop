provider "aws" {
  region = var.region
}

provider "github" {
  token = var.git_token
  owner = split("/", var.git_repo)[0]
}

resource "random_string" "this" {
  lower   = true
  upper   = false
  special = false
  length  = 6
}

locals {
  deployEKS = var.deploy_eks == true ? 1 : 0
}

# // ------------------------------------------------------------------------------------
# // Network Infrastructure / Public and Private Subnets, IGW, NAT GW, Route Tables
#

module "network-hub" {
  source = "./modules/network-hub"

  region                    = var.region
  eks_cluster_name          = var.eks_cluster_name
}

# // ------------------------------------------------------------------------------------
# // Database / RDS
#

resource "aws_db_instance" "this" {
  db_name                = "raygun${random_string.this.id}"
  allocated_storage      = 10
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  username               = "rdsuser"
  password               = "thiswillbedestroyed!123!"
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [ module.network-hub.security_group_id ]
  skip_final_snapshot    = true
  tags                   = var.s3_tags
}

resource "aws_db_subnet_group" "this" {
  name        = "rds-private"
  subnet_ids  = module.network-hub.private_subnet_id
}

resource "aws_db_snapshot" "this" {
  db_instance_identifier = aws_db_instance.this.identifier
  db_snapshot_identifier = "initialsnap"
}

# // ------------------------------------------------------------------------------------
# // Container Registry / ECR
#

module "ecr" {
  source  = "./modules/ecr"
  s3_arn  = module.s3.arn
  region  = var.region
}

# // ------------------------------------------------------------------------------------
# // Virtual Machines / EC2
#

module "vmhosts" {
  source = "./modules/ec2"

  public_subnet_id = module.network-hub.public_subnet_id
  vpcId            = module.network-hub.vpc_id
  vmhosts          = var.vmhosts
  instance_profile = module.ecr.iamInstanceProfileName
  region           = var.region

}

# // ------------------------------------------------------------------------------------
# // Storage / S3 Buckets
#

module "s3" {
  source = "./modules/s3"

  region      = var.region
  s3_files    = var.s3_files
  tags        = var.s3_tags
}

resource "aws_s3_bucket" "hr" {
  bucket        = "hr-data-${random_string.this.id}"
  force_destroy = true
  tags = {
    Environment = "prod"
    Terraform   = "true"
    Department  = "HR"
    Criticality = "High"
    Owner       = "Martha Stewart"
    Project     = "RayGun"
  }
}

resource "aws_s3_bucket" "appdev" {
  bucket        = "appdev-data-${random_string.this.id}"
  force_destroy = true
  tags = {
    Environment = "dev"
    Terraform   = "true"
    Department  = "AppDev"
    Criticality = "Low"
    Owner       = "Snoop Dog"
    Project     = "RayGun v2 Exploration"
  }
}

# // ------------------------------------------------------------------------------------
# // K8S / EKS
#

# module "eks" {
#   //source  = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=7cd3be3fbbb695105a447b37c4653a00b0b51b94"
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 20.0" # Use a recent, stable version

#   cluster_name    = var.eks_cluster_name
#   cluster_version = var.cluster_version

#   cluster_endpoint_public_access  = true
#   cluster_endpoint_private_access = true

#   cluster_addons = {
#        aws-load-balancer-controller = {
#       # The add-on will be deployed with an IAM role for its service account
#       create_iam_role = true
#     }
#     coredns = {
#       most_recent = true
#     }
#     kube-proxy = {
#       most_recent = true
#     }
#     vpc-cni = {
#       most_recent = true
#     }
#   }

#   vpc_id                   = module.network-hub.vpc_id
#   subnet_ids               = flatten([module.network-hub.public_subnet_id])
#   control_plane_subnet_ids = flatten([module.network-hub.private_subnet_id])

#   # EKS Managed Node Group(s)
#   eks_managed_node_group_defaults = {
#     instance_types = [ var.eks_node_size ]
#   }

#   eks_managed_node_groups = {
#     c2c = {
#       min_size     = 1
#       max_size     = 3
#       desired_size = 2

#       ami_type       = "AL2023_x86_64_STANDARD"
#       instance_types = [ var.eks_node_size ]
#       capacity_type  = "SPOT"
#     }
#   }

#   # Cluster access entry
#   enable_cluster_creator_admin_permissions = true

#   tags = {
#     Environment = "prod"
#     Terraform   = "true"
#     Owner       = "RayGun AppDev Team"
#     Project     = "RayGun"
#   }
# }

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0" # Use a recent, stable version

  cluster_name    = var.eks_cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_addons = {
    eks-pod-identity-agent = {}
    coredns = {}
    kube-proxy = {}
    vpc-cni = {}
  }

  vpc_id                   = module.network-hub.vpc_id
  subnet_ids               = flatten([module.network-hub.public_subnet_id])
  control_plane_subnet_ids = flatten([module.network-hub.private_subnet_id])

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = [ var.eks_node_size ]
  }

  eks_managed_node_groups = {
    c2c = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = [ var.eks_node_size ]
      capacity_type  = "SPOT"
    }
  }

  # Cluster access entry
  enable_cluster_creator_admin_permissions = true

  tags = {
    Environment = "prod"
    Terraform   = "true"
    Owner       = "RayGun AppDev Team"
    Project     = "RayGun"
  }
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

# // ------------------------------------------------------------------------------------
# // GitHub Secrets from Terraform Output
#

data "github_actions_public_key" "this" {
  repository = split("/", var.git_repo)[1]
}

resource "github_actions_secret" "instance_ips" {
  repository       = split("/", var.git_repo)[1]
  secret_name      = "INSTANCE_IPS"
  plaintext_value  = jsonencode(module.vmhosts.publicIPs)
}

resource "github_actions_secret" "instance_sgs" {
  repository       = split("/", var.git_repo)[1]
  secret_name      = "INSTANCE_SGS"
  plaintext_value  = jsonencode(module.vmhosts.securityGroupIds)
}

resource "github_actions_secret" "sshkey" {
  repository      = split("/", var.git_repo)[1]
  secret_name     = "EC2_KEY"
  plaintext_value = module.vmhosts.sshPrivateKey
}