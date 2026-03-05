# ===========================
# ECS - Elastic Container Service
# ===========================

# ECS Cluster
resource "aws_ecs_cluster" "video_core" {
  name = "video-core-cluster-${var.environment}"

  tags = {
    Name        = "Video Core ECS Cluster"
    Environment = var.environment
  }
}

# CloudWatch Log Group for ECS
resource "aws_cloudwatch_log_group" "video_core" {
  name              = "/ecs/video-core-${var.environment}"
  retention_in_days = 7

  tags = {
    Name        = "Video Core ECS Logs"
    Environment = var.environment
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "video_core" {
  family                   = "video-core-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"  # 0.25 vCPU
  memory                   = "512"  # 512 MB
  
  # Usar LabRole do AWS Academy
  execution_role_arn = data.aws_iam_role.lab_role.arn
  task_role_arn      = data.aws_iam_role.lab_role.arn

  container_definitions = jsonencode([
    {
      name             = "video-core-api"
      image            = "${aws_ecr_repository.video_core.repository_url}:latest"
      essential        = true
      portMappings     = local.ecs_port_mappings
      environment      = local.ecs_container_environment
      logConfiguration = local.ecs_log_configuration
    }
  ])

  tags = {
    Name        = "Video Core Task Definition"
    Environment = var.environment
  }
}

# ECS Service
resource "aws_ecs_service" "video_core" {
  name            = "video-core-service-${var.environment}"
  cluster         = aws_ecs_cluster.video_core.id
  task_definition = aws_ecs_task_definition.video_core.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = local.rds_subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  tags = {
    Name        = "Video Core ECS Service"
    Environment = var.environment
  }
}
