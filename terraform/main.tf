provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "video-core"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
