variable "region" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "public_subnet_cidr_block" {
  type = list(string)
}

variable "private_subnet_cidr_block" {
  type = list(string)
}

variable "instance_type" {
  default = "t2.small"
}

variable "key_name" {
  type = string
}

variable "s3_tags" {
  type = map(any)
}

variable "ecr_name" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "deploy_eks" {
  type = bool
}

variable "s3_files" {
  type = map(any)
  default = {
    file1 = "sampledata/cardholder_data_primary.csv"
    file2 = "sampledata/cardholder_data_secondary.csv"
    file3 = "sampledata/cardholders_corporate.csv"
  }
}

variable "eks_cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "vmhosts" {
  description = "List of VM hosts with their configuration"
  type = list(object({
    name           = string
    ami            = string
    install_script = string
    tags           = map(string)
    defender       = bool
    defender_type  = string #host or container
    run_containers = bool 
    private_ip     = string
    ports          = list(number)
    cidrs          = list(string)
  }))
}

variable "git_repo" {
  type = string #// Format: OrgName/RepoName
}

variable "git_token" {
  type      = string
  sensitive = true
  default   = ""
}