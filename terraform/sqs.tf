# SQS queue for video processing events
resource "aws_sqs_queue" "video_events" {
  name                       = "video-events-${var.environment}"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 345600  # 4 days
  receive_wait_time_seconds  = 0
  visibility_timeout_seconds = 30

  tags = {
    Name        = "Video Events Queue"
    Description = "Queue for video processing events"
  }
}

# Dead letter queue for failed messages
resource "aws_sqs_queue" "video_events_dlq" {
  name                       = "video-events-dlq-${var.environment}"
  message_retention_seconds  = 1209600  # 14 days
  receive_wait_time_seconds  = 0

  tags = {
    Name        = "Video Events DLQ"
    Description = "Dead letter queue for failed video events"
  }
}

# Redrive policy to send failed messages to DLQ
resource "aws_sqs_queue_redrive_policy" "video_events" {
  queue_url = aws_sqs_queue.video_events.id
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.video_events_dlq.arn
    maxReceiveCount     = 3
  })
}
