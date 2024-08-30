variable "region" {
  default = "us-east-2"
}

variable "cidr_block" {
  default = "10.100.0.0/20"
}

variable "public_subnet_cidr_block" {
  default = [
   "10.100.0.0/24",
   "10.100.1.0/24",
   "10.100.2.0/24" 
  ]
}

variable "private_subnet_cidr_block" {
  default = [
   "10.100.10.0/24",
   "10.100.11.0/24",
   "10.100.12.0/24" 
  ]
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
  default = "code2cloud"
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
  type = string
}

variable "git_token" {
  type      = string
  sensitive = true
  default   = ""
}