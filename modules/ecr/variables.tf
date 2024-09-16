variable "region" {
  type = string
}

variable "ecr_name" {
  type    = string
  default = "pc-ecr"
}

variable "s3_arn" {
  type = string
}