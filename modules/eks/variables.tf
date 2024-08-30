variable "name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "cluster_version" {
  type        = string
  default     = "1.27"
  description = "Kubernetes version"
}

variable "environment" {
  type        = string
  default     = "prod"
  description = "Environment in which the cluster is being created"
}

variable "private_subnets_ids" {
  type        = list(any)
  default     = []
  description = "IDs of the private subnets"
}

variable "public_subnets_ids" {
  type        = list(any)
  default     = []
  description = "IDs of the public subnets"
}

variable "namespaces" {
  type        = list(any)
  default     = ["kube-system", "default"]
  description = "Namespaces list held by Fargate"
}

variable "kubeconfig_template_path" {
  type        = string
  default     = "kubeconfig.tftpl"
  description = "Kubeconfig template name"
}