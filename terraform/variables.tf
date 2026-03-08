variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "bucket_video_files" {
  description = "Stores videos uploaded by users" 
  type = string
  default = "video-files-fiapx-prod"  # Adicione algo único
}

variable "sqs_processing_queue" {
  description = "Queue for processing jobs"
  type = string
  default = "video-processing-jobs-queue"
}

variable "sqs_video-processed-queue" {
  description = "Queue for processed jobs"
  type = string
  default = "video-processed-queue"
}

variable "db_password" {
  description = "Password for RDS database"
  type        = string
  sensitive   = true
  default     = "videocore123"
}

variable "jwt_secret" {
  description = "Secret key for JWT token generation"
  type        = string
  sensitive   = true
  default     = "your-secret-key-change-in-production"
}

variable "resend_api_key" {
  description = "Resend API Key for sending emails"
  type        = string
  sensitive   = true
  default     = "re_D7fXDbUL_4HtuHvSnkn6TLtTTwEnbXZCR"
}

variable "email_from" {
  description = "Email address to send emails from"
  type        = string
  default     = "noreply@resend.dev"
}

