#Secret S3 Bucket
resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = true
  tags = merge(var.tags, {})
}

resource "aws_s3_object" "this" {
  for_each = var.s3_files
  bucket   = aws_s3_bucket.this.id
  key      = each.key
  source   = each.value
}

resource "aws_s3_bucket" "log_bucket" {
  bucket        = "pc-em-diglog-bucket"
  force_destroy = true
  tags = {}
}

resource "aws_s3_bucket_logging" "this" {
  bucket = aws_s3_bucket.this.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}