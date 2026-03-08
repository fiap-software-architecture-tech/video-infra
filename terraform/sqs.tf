# SQS queue for video processing events
resource "aws_sqs_queue" "video_job_queue" {
  name                       = "${var.sqs_processing_queue}"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 345600  # 4 days
  receive_wait_time_seconds  = 0
  visibility_timeout_seconds = 960  # 16 minutes (maior que timeout da Lambda de 15min)

  tags = {
    Name        = "Video Events Queue"
    Description = "Queue for video processing events"
  }
}

resource "aws_sqs_queue" "video_events_dlq" {
  name                       = "${var.sqs_processing_queue}-dlq"
  message_retention_seconds  = 1209600  # 14 days
  receive_wait_time_seconds  = 0

  tags = {
    Name        = "Video Events DLQ"
    Description = "Dead letter queue for failed video events"
  }
}

resource "aws_sqs_queue_redrive_policy" "video_job_queue" {
  queue_url = aws_sqs_queue.video_job_queue.id
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.video_events_dlq.arn
    maxReceiveCount     = 3
  })
}

# SQS queue for processed video events
resource "aws_sqs_queue" "video_processed_queue" {
  name                       = "${var.sqs_video-processed-queue}"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 345600  # 4 days
  receive_wait_time_seconds  = 0
  visibility_timeout_seconds = 30

  tags = {
    Name        = "Video Processed Queue"
    Description = "Queue for processed video events"
  }
}