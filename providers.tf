terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.45.0"
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
    # prismacloudcompute = {
    #   source = "PaloAltoNetworks/prismacloudcompute"
    #   version = "0.8.0"
    # }    
  }
}