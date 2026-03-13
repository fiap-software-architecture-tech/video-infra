# Backend configuration for storing Terraform state in S3
# IMPORTANT: First apply with this block commented out to create the S3 bucket
# Then uncomment and run 'terraform init -migrate-state' to move state to S3

# terraform {
#   backend "s3" {
#     bucket  = "video-core-terraform-state"
#     key     = "terraform.tfstate"
#     region  = "us-east-1"
#     encrypt = true
#   }
# }
