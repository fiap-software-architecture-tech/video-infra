# 🚀 Deploy Rápido - Lambda Video Processing

Este guia mostra como fazer o deploy da infraestrutura e código da Lambda para processamento de vídeos.

> **Nota**: A infraestrutura (video-infra) cria a estrutura da Lambda. O código é deployado pelo repositório video-processing-service.

## ⚡ Quick Start

### 1️⃣ Deploy da Infraestrutura (video-infra)

```bash
cd video-infra/terraform

# Primeira vez: inicializar
terraform init

# Ver o que será criado
terraform plan

# Criar a Lambda (estrutura apenas, sem código)
terraform apply
```

### 2️⃣ Deploy do Código (video-processing-service)

```bash
cd video-processing-service

# Configurar variáveis
export AWS_REGION=us-east-1
export LAMBDA_FUNCTION_NAME=video-processing-prod

# Deploy do código
chmod +x scripts/deploy-lambda.sh
./scripts/deploy-lambda.sh
```

### 3️⃣ Verificar Outputs

```bash
cd video-infra/terraform
terraform output
```

Você verá informações como:
- `lambda_function_name`: Nome da função Lambda
- `lambda_function_arn`: ARN da Lambda
- `lambda_function_url`: URL para invocar a Lambda diretamente
- `lambda_log_group`: Grupo de logs no CloudWatch

## 📋 Separação de Responsabilidades

### video-infra (Terraform)
Cria e gerencia:
- ✅ Lambda function (estrutura)
- ✅ IAM Role
- ✅ VPC Configuration
- ✅ Event Source Mapping (SQS trigger)
- ✅ CloudWatch Log Group
- ✅ Function URL

### video-processing-service
Gerencia:
- ✅ Código da aplicação
- ✅ Build do TypeScript
- ✅ Empacotamento (ZIP)
- ✅ Deploy do código via AWS CLI

Este modelo separa infraestrutura (IaC) do código da aplicação, permitindo deploys independentes.

## 📦 O que foi criado?

### Lambda Function
- **Nome**: `video-processing-{environment}`
- **Runtime**: Node.js 20.x
- **Timeout**: 15 minutos
- *bash
cd video-processing-service
./scripts/deploy-lambda.sh
```

O script faz automaticamente:
- Build do TypeScript
- Instalação de dependências de produção
- Criação do ZIP
- Upload para a Lambda
- Aguarda atualização completar

**Não é necessário** rodar `terraform apply` novamente
- **Security Group**: Compartilhado com ECS tasks

### Logs
- **CloudWatch Log Group**: `/aws/lambda/video-processing-{environment}`
- **Retenção**: 7 dias

## 🔄 Atualizar o Código da Lambda

Depois de fazer mudanças no código:

```powershell
# 1. Rebuild
cd video-processing-service
.\scripts\build-lambda.ps1

# 2. Reapply
cd ..\video-infra\terraform
terraform apply
```

O Terraform detectará automaticamente a mudança no hash do arquivo ZIP.

## 🐛 Debugging

###bash
# Usando AWS CLI
aws logs tail /aws/lambda/video-processing-prod --follow
```

### Testar a Lambda manualmente

```bash
# Testar via Function URL (se habilitada)
curl -X POST $(terraform output -raw lambda_function_url) \
  -H "Content-Type: application/json" \
  -d '{"Records":[]}'

# Ou invocar diretamente
aws lambda invoke \
  --function-name video-processing-prod \
  --region us-east-1 \
  --payload '{"Records":[]}' \
  response.json
```

### Enviar mensagem de teste para a fila

```bash
# Obter URL da fila
QUEUE_URL=$(cd video-infra/terraform && terraform output -raw video_job_queue_url)

# Enviar mensagem
aws sqs send-message \
  --queue-url $QUEUE_URL \
  --message-body '{"videoId":"teste123","action":"process"}' \
  --region us-easdeployment failed

**Verificar**:
1. A infraestrutura foi criada com `terraform apply`?
2. O script `deploy-lambda.sh` foi executado?
3. Há erros no build do TypeScript?

### Primeira execução da Lambda falha

**Normal**: O placeholder inicial será substituído no primeiro deploy do código. Execute o script `deploy-lambda.sh`.

### Erro: ECR não vazio no `terraform destroy`

**Solução**: Já foi adicionado `force_delete = true` no ECR. Agora o `terraform destroy` funcionará sem erros.

### Erro: Lambda não inicia

**Verificar**:
1. O arquivo ZIP existe em `video-infra/terraform/video-processing-service.zip`?
2. O build foi feito corretamente?
3. As dependências de produção foram instaladas?

### Erro: Lambda timeout

**Verificar**:
1. O vídeo é muito grande?
2. O processamento FFmpeg está demorando mais de 15 minutos?
3. Considere aumentar o timeout ou otimizar o código

### Lambda não tem acesso ao S3/SQS

**Verificar**:
1. A Lambda está usando o LabRole do AWS Academy?
2. O LabRole tem permissões para S3 e SQS?

## 🔐 Segurança

### Function URL
Por padrão, a Function URL está configurada com `authorization_type = "NONE"` para facilitar testes.

**Em produção**, altere para:
```terraform
authorization_type = "AWS_IAM"
```

Ou remova completamente o recurso `aws_lambda_function_url` se não precisar de acesso direto via HTTP.

## 📊 Monitoramento

### CloudWatch Metrics Importantes

- **Invocations**: Número de invocações
- **Duration**: Tempo de execução
- **Errors**: Número de erros
- **Throttles**: Número de throttles (se houver limite de concorrência)
- **ConcurrentExecutions**: Execuções simultâneas

Acesse: AWS Console → CloudWatch → Metrics → Lambda

### Alarmes Recomendados

Configure alarmes para:
- Taxa de erro > 5%
- Duration próxima ao timeout (> 800 segundos)
- Throttles > 0

## 💰 Custos

A Lambda é cobrada por:
- Número de invocações
- Duração da execução (GB-segundo)
- Dados processados

Com 1GB de memória e 15 minutos de timeout, cada invocação custará aproximadamente:
- ~$0.0025 por execução (considerando execução completa)

**AWS Free Tier**: Primeiros 1M de invocações e 400.000 GB-segundo por mês são gratuitos.

## 📚 Referências

- [AWS Lambda Docs](https://docs.aws.amazon.com/lambda/)
- [Terraform AWS Provider - Lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)
- [FFmpeg Documentation](https://ffmpeg.org/documentation.html)
