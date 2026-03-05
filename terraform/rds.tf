# ===========================
# RDS - Relational Database Service
# ===========================

# Security Group for RDS
resource "aws_security_group" "rds" {
  name        = "video-core-rds-sg-${var.environment}"
  description = "Security group for RDS MySQL database"
  vpc_id      = data.aws_vpc.existing.id

  # Permite acesso do ECS na porta MySQL
  ingress {
    description     = "MySQL from ECS"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Video Core RDS Security Group"
    Environment = var.environment
  }
}

# Security Group for ECS Tasks
resource "aws_security_group" "ecs_tasks" {
  name        = "video-core-ecs-tasks-sg-${var.environment}"
  description = "Security group for ECS tasks"
  vpc_id      = data.aws_vpc.existing.id

  # Permite tráfego HTTP na porta 3000 (para acesso externo)
  ingress {
    description = "HTTP from internet"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permite saída para internet (S3, SQS, RDS, etc)
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Video Core ECS Tasks Security Group"
    Environment = var.environment
  }
}

# DB Subnet Group (obrigatório para RDS)
resource "aws_db_subnet_group" "video_core" {
  name       = "video-core-db-subnet-group-${var.environment}"
  subnet_ids = local.rds_subnet_ids

  tags = {
    Name        = "Video Core DB Subnet Group"
    Environment = var.environment
  }
}

# RDS MySQL Instance
resource "aws_db_instance" "video_core" {
  identifier     = "video-core-db-${var.environment}"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"  # Free tier eligible

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp2"

  db_name  = "videocore"
  username = "admin"
  password = var.db_password  # Adicionar variável

  db_subnet_group_name   = aws_db_subnet_group.video_core.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Configurações para reduzir custos
  backup_retention_period = 0  # Sem backups automáticos
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false

  tags = {
    Name        = "Video Core Database"
    Environment = var.environment
  }
}
