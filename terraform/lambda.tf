# ===========================
# AWS Lambda - Video Processing
# ===========================
# 
# Este arquivo cria apenas a ESTRUTURA da Lambda function.
# O CÓDIGO da aplicação é deployado pelo repositório video-processing-service
# usando o script deploy-lambda.sh que faz upload via AWS CLI.
#
# Esta separação permite:
# - Infraestrutura gerenciada por Terraform (IaC)
# - Código da aplicação deployado independentemente
# - Deploys mais rápidos (não precisa terraform apply para atualizar código)
# ===========================

# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "video_processing_lambda" {
  name              = "/aws/lambda/video-processing-${var.environment}"
  retention_in_days = 7

  tags = {
    Name        = "Video Processing Lambda Logs"
    Environment = var.environment
  }
}

# Lambda Function
resource "aws_lambda_function" "video_processing" {
  function_name = "video-processing-${var.environment}"
  role          = data.aws_iam_role.lab_role.arn
  
  # O código será deployado pelo script deploy-lambda.sh do repositório video-processing-service
  # Este recurso cria apenas a estrutura da Lambda
  package_type = "Zip"
  handler      = "index.handler"
  runtime      = "nodejs20.x"
  
  # Placeholder para primeira criação - será substituído pelo script de deploy
  filename         = "${path.module}/lambda-placeholder.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda-placeholder.zip")
  
  # Timeout de 15 minutos
  timeout = 900
  
  # 1GB de memória para processar vídeos
  memory_size = 1024
  
  # Ephemeral storage para vídeos temporários (até 10GB)
  ephemeral_storage {
    size = 2048  # 2GB
  }
  
  # Variáveis de ambiente
  environment {
    variables = {
      NODE_ENV        = "prd"
      AWS_ENDPOINT    = ""
      AWS_BUCKET_NAME = aws_s3_bucket.video-bucket.id
      AWS_SQS_URL     = aws_sqs_queue.video_processed_queue.url
    }
  }
  
  tags = {
    Name        = "Video Processing Lambda"
    Environment = var.environment
  }
  
  depends_on = [
    aws_cloudwatch_log_group.video_processing_lambda
  ]
  
  # Ignora mudanças no código, pois será gerenciado pelo script deploy-lambda.sh
  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      last_modified
    ]
  }
}

# Event Source Mapping - Conecta Lambda com SQS
resource "aws_lambda_event_source_mapping" "video_processing_queue" {
  event_source_arn = aws_sqs_queue.video_job_queue.arn
  function_name    = aws_lambda_function.video_processing.arn
  
  # Processa 1 mensagem por vez
  batch_size = 1
  
  # Configurações de retry
  maximum_batching_window_in_seconds = 0
  
  # Ensure visibility timeout is greater than lambda timeout + buffer
  function_response_types = ["ReportBatchItemFailures"]
  
  enabled = true
}

# Lambda Function URL (opcional - para testes diretos)
resource "aws_lambda_function_url" "video_processing" {
  function_name      = aws_lambda_function.video_processing.function_name
  authorization_type = "NONE"  # Mude para "AWS_IAM" em produção
  
  cors {
    allow_origins     = ["*"]
    allow_methods     = ["POST"]
    allow_headers     = ["*"]
    max_age           = 86400
  }
}
