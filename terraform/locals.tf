# ===========================
# LOCAL VARIABLES
# ===========================

locals {
  # Subnet IDs for RDS and ECS
  rds_subnet_ids = [
    data.aws_subnet.fiapx_subnet_1a.id,  # us-east-1a
    data.aws_subnet.fiapx_subnet_1b.id,  # us-east-1b
  ]
  # Environment variables for ECS containers
  ecs_container_environment = [
    {
      name  = "NODE_ENV"
      value = "prd"
    },
    {
      name  = "PORT"
      value = "3000"
    },
    {
      name  = "JWT_SECRET"
      value = var.jwt_secret
    },
    {
      name  = "JWT_EXPIRES_IN"
      value = "1h"
    },
    {
      name  = "AWS_REGION"
      value = var.aws_region
    },
    {
      name  = "AWS_ENDPOINT"
      value = ""
    },
    {
      name  = "AWS_BUCKET_NAME"
      value = aws_s3_bucket.video-bucket.id
    },
    {
      name  = "AWS_SQS_URL"
      value = aws_sqs_queue.video_job_queue.url
    },
    {
      name  = "DATABASE_URL"
      value = "mysql://${aws_db_instance.video_core.username}:${var.db_password}@${aws_db_instance.video_core.endpoint}/${aws_db_instance.video_core.db_name}"
    },
    {
      name  = "DATABASE_HOST"
      value = split(":", aws_db_instance.video_core.endpoint)[0]
    },
    {
      name  = "DATABASE_PORT"
      value = "3306"
    },
    {
      name  = "DATABASE_USER"
      value = aws_db_instance.video_core.username
    },
    {
      name  = "DATABASE_PASS"
      value = var.db_password
    },
    {
      name  = "DATABASE_NAME"
      value = aws_db_instance.video_core.db_name
    }
  ]

  # CloudWatch log configuration
  ecs_log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-group"         = aws_cloudwatch_log_group.video_core.name
      "awslogs-region"        = var.aws_region
      "awslogs-stream-prefix" = "api"
    }
  }

  # Container port mappings
  ecs_port_mappings = [
    {
      containerPort = 3000
      protocol      = "tcp"
    }
  ]
}
