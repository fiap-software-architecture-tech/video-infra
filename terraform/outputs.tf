output "terraform_state_bucket" {
  description = "S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "terraform_state_bucket_arn" {
  description = "ARN of the Terraform state bucket"
  value       = aws_s3_bucket.terraform_state.arn
}

output "video-bucket_name" {
  description = "S3 bucket for video storage"
  value       = aws_s3_bucket.video-bucket.id
}

output "video-bucket_arn" {
  description = "ARN of the video storage bucket"
  value       = aws_s3_bucket.video-bucket.arn
}

output "video_job_queue_url" {
  description = "URL of the video job processing SQS queue"
  value       = aws_sqs_queue.video_job_queue.url
}

output "video_job_queue_arn" {
  description = "ARN of the video job processing SQS queue"
  value       = aws_sqs_queue.video_job_queue.arn
}

output "video_job_dlq_url" {
  description = "URL of the video job processing dead letter queue"
  value       = aws_sqs_queue.video_events_dlq.url
}

output "video_job_dlq_arn" {
  description = "ARN of the video job processing dead letter queue"
  value       = aws_sqs_queue.video_events_dlq.arn
}

# Data Source Outputs
output "vpc_id" {
  description = "ID of the existing VPC"
  value       = data.aws_vpc.existing.id
}

output "lab_role_arn" {
  description = "ARN of the AWS Academy LabRole"
  value       = data.aws_iam_role.lab_role.arn
}

output "rds_subnet_ids" {
  description = "List of subnet IDs for RDS"
  value       = local.rds_subnet_ids
}

output "video_processed_queue_url" {
  description = "URL of the video processed events SQS queue"
  value       = aws_sqs_queue.video_processed_queue.url
}

output "video_processed_queue_arn" {
  description = "ARN of the video processed events SQS queue"
  value       = aws_sqs_queue.video_processed_queue.arn
}