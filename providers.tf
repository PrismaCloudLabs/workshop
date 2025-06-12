terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.95.0"
    }
    google = {
      source = "hashicorp/google"
      version = "5.31.0"
    }
    github = {
      source = "integrations/github"
      version = "6.2.3"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.2"
    }    
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.5"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.10"
    }
  }
}