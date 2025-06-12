
resource "random_string" "this" {
  lower   = true
  upper   = false
  special = false
  length  = 6
}

#Secret S3 Bucket
resource "aws_s3_bucket" "this" {
  bucket        = "${lower(var.bucket_name)}-${random_string.this.id}"
  force_destroy = true
  tags          = merge(var.tags, {})
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "public-read"
}

resource "aws_s3_object" "this" {
  for_each = var.s3_files
  bucket   = aws_s3_bucket.this.id
  key      = each.key
  source   = each.value
}

resource "aws_s3_bucket" "log_bucket" {
  bucket        = lower("log-bucket-${random_string.this.id}")
  force_destroy = true
  tags = {}
}

resource "aws_s3_bucket_logging" "this" {
  bucket = aws_s3_bucket.this.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}