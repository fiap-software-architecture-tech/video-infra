# S3 bucket for Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "video-core-terraform-state-${var.environment}"

  tags = {
    Name        = "Terraform State Bucket"
    Description = "Stores Terraform state files"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket for video storage
resource "aws_s3_bucket" "video-bucket" {
  bucket = "${var.bucket_video_files}"

  tags = {
    Name        = "Video Storage Bucket"
    Description = "Stores uploaded videos"
  }
}
