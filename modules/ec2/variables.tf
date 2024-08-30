variable "vpcId" {
  type = string
}

variable "instance_type" {
  default = "t2.small"
}

variable "key_name" {
  type = string
}

variable "public_subnet_id" {
  type = list(any)
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
    private_ip     = string
    ports          = list(number)
    cidrs          = list(string)
  }))
}