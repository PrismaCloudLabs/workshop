variable "region" {
  type = string
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

variable "eks_cluster_name" {
  type = string
  default = "na"
}