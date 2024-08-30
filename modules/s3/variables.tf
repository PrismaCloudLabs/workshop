variable "region" {
  default = "us-east-2"
}

variable "bucket_name" {
  default = "pc-lab-bucket"
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