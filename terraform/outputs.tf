output "terraform_state_bucket" {
  description = "S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "terraform_state_bucket_arn" {
  description = "ARN of the Terraform state bucket"
  value       = aws_s3_bucket.terraform_state.arn
}

output "video_bucket_name" {
  description = "S3 bucket for video storage"
  value       = aws_s3_bucket.video_bucket.id
}

output "video_bucket_arn" {
  description = "ARN of the video storage bucket"
  value       = aws_s3_bucket.video_bucket.arn
}

output "video_events_queue_url" {
  description = "URL of the video events SQS queue"
  value       = aws_sqs_queue.video_events.url
}

output "video_events_queue_arn" {
  description = "ARN of the video events SQS queue"
  value       = aws_sqs_queue.video_events.arn
}

output "video_events_dlq_url" {
  description = "URL of the video events dead letter queue"
  value       = aws_sqs_queue.video_events_dlq.url
}
