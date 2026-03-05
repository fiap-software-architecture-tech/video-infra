# ===========================
# ECR - Elastic Container Registry
# ===========================

# ECR repository for video-core application
resource "aws_ecr_repository" "video_core" {
  name                 = "video-core-image"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name        = "Video Core ECR Repository"
    Description = "Container images for video-core application"
    Environment = var.environment
  }
}
