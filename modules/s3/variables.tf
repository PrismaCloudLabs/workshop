variable "region" {
  type = string
}

variable "bucket_name" {
  type    = string
  default = "pc-data"
}

variable "s3_files" {
  type = map(any)
  default = {
    file1 = "data/file1"
    file2 = "data/file2"
  }
}

variable "tags" {
  default = {
    Terraform: "true"
  }
}