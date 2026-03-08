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

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
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

# ECR Outputs
output "ecr_repository_url" {
  description = "URL of the ECR repository for video-core"
  value       = aws_ecr_repository.video_core.repository_url
}

output "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.video_core.arn
}

output "ecr_repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.video_core.name
}

# ECS Outputs
output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.video_core.name
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.video_core.arn
}

output "ecs_task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.video_core.arn
}

output "ecs_task_definition_family" {
  description = "Family of the ECS task definition"
  value       = aws_ecs_task_definition.video_core.family
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.video_core.name
}

# RDS Outputs
output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.video_core.endpoint
}

output "rds_database_name" {
  description = "RDS database name"
  value       = aws_db_instance.video_core.db_name
}

output "rds_username" {
  description = "RDS database username"
  value       = aws_db_instance.video_core.username
  sensitive   = true
}

output "database_url" {
  description = "Complete database connection URL"
  value       = "mysql://${aws_db_instance.video_core.username}:${var.db_password}@${aws_db_instance.video_core.endpoint}/${aws_db_instance.video_core.db_name}"
  sensitive   = true
}

# Lambda Outputs
output "lambda_function_name" {
  description = "Name of the video processing Lambda function"
  value       = aws_lambda_function.video_processing.function_name
}

output "lambda_function_arn" {
  description = "ARN of the video processing Lambda function"
  value       = aws_lambda_function.video_processing.arn
}

output "lambda_function_url" {
  description = "URL endpoint for the Lambda function"
  value       = aws_lambda_function_url.video_processing.function_url
}

output "lambda_log_group" {
  description = "CloudWatch log group for Lambda"
  value       = aws_cloudwatch_log_group.video_processing_lambda.name
}

# Aliases for easier access
output "s3_bucket_name" {
  description = "Alias for video-bucket_name"
  value       = aws_s3_bucket.video-bucket.id
}

output "db_name" {
  description = "Alias for rds_database_name"
  value       = aws_db_instance.video_core.db_name
}

output "db_username" {
  description = "Alias for rds_username"
  value       = aws_db_instance.video_core.username
  sensitive   = true
}

output "sqs_queue_url" {
  description = "Alias for video_job_queue_url"
  value       = aws_sqs_queue.video_job_queue.url
}

output "ecr_repository_url_core" {
  description = "Alias for ecr_repository_url"
  value       = aws_ecr_repository.video_core.repository_url
}