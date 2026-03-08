# video-infra

Repositório responsável pela definição, provisionamento e orquestração da infraestrutura da plataforma de processamento de vídeos na AWS usando Terraform.

## 📌 Visão Geral

O **video-infra** centraliza todos os artefatos necessários para subir e operar o ecossistema de microsserviços da aplicação. Seu objetivo é garantir padronização de ambientes, reprodutibilidade de deploys e suporte à escalabilidade da solução.

## 🚀 Responsabilidades

- Provisionamento de recursos AWS via Terraform (S3, SQS)
- Configuração de backend remoto para estado do Terraform
- Armazenamento de vídeos (S3)
- Mensageria para eventos (SQS)

## 🧱 Recursos Provisionados

### AWS Resources (Terraform)
- **S3 Buckets:**
  - Terraform state backend (com versionamento e criptografia)
  - Video storage (com CORS, lifecycle policy e versionamento)
- **SQS Queues:**
  - video-processing-jobs-queue (fila principal para processamento)
  - video-processing-jobs-queue-dlq (dead letter queue)
  - video-processed-queue (fila de vídeos processados)
- **ECR (Elastic Container Registry):**
  - video-core-image (imagens Docker do video-core)
- **ECS (Elastic Container Service):**
  - Cluster ECS Fargate
  - Task Definition e Service para video-core API
- **RDS (Relational Database Service):**
  - MySQL 8.0 (db.t3.micro)
  - Security Groups configurados
- **Lambda:**
  - video-processing-service (processamento assíncrono de vídeos)
  - CloudWatch Logs
  - Event Source Mapping com SQS

## 🎬 Video Processing Lambda

A Lambda `video-processing-service` é responsável por processar vídeos de forma assíncrona:

- **Runtime**: Node.js 20.x
- **Timeout**: 15 minutos (900 segundos)
- **Memória**: 1GB
- **Trigger**: Mensagens na fila SQS (video-processing-jobs-queue)
- **Batch Size**: 1 mensagem por vez

### Separação de Responsabilidades

**Este repositório (video-infra)** cria apenas a estrutura da Lambda:
- ✅ Lambda function (sem código)
- ✅ IAM Roles
- ✅ VPC Configuration
- ✅ Event Source Mapping com SQS
- ✅ CloudWatch Log Group

**O repositório video-processing-service** é responsável por:
- ✅ Código da aplicação
- ✅ Build e deploy do código
- ✅ Script `deploy-lambda.sh`

### Como funciona

1. `terraform apply` cria a Lambda com um placeholder
2. Script `deploy-lambda.sh` (no video-processing-service) faz upload do código real
3. Atualizações de código não requerem `terraform apply`

Para mais detalhes, consulte [LAMBDA_DEPLOY.md](LAMBDA_DEPLOY.md).

## 📋 Pré-requisitos

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configurado com credenciais
- Conta AWS com permissões para criar recursos S3 e SQS

## ⚙️ Como subir o ambiente

### 1. Configurar credenciais AWS

```bash
aws configure
```

### 2. Inicializar Terraform

```bash
cd video-infra/terraform
terraform init
```

### 3. Criar arquivo de variáveis

```bash
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars com seus valores
```

### 4. Planejar e aplicar (primeira vez)

**IMPORTANTE:** Na primeira execução, o backend S3 está comentado em `backend.tf` porque o bucket ainda não existe.

```bash
# Visualizar mudanças
terraform plan

# Aplicar mudanças
terraform apply
```

Após a primeira aplicação, os buckets S3 estarão criados.

### 5. Migrar estado para S3 (recomendado)

Depois que os recursos forem criados, descomente o bloco `backend` no arquivo `backend.tf` e execute:

```bash
terraform init -migrate-state
```

Isso moverá o estado local para o bucket S3.

### 6. Outputs

Para visualizar os recursos criados:

```bash
terraform output
```

## 🗂️ Estrutura de Arquivos

```
video-infra/
├── .gitignore
├── README.md
└── terraform/
    ├── backend.tf           # Configuração do backend S3 (comentado inicialmente)
    ├── main.tf              # Provider AWS e configurações principais
    ├── variables.tf         # Definição de variáveis
    ├── outputs.tf           # Outputs dos recursos criados
    ├── data-sources.tf      # Data sources (VPC, subnets, IAM roles)
    ├── s3.tf                # Recursos S3 (buckets)
    ├── sqs.tf               # Recursos SQS (filas)
    ├── ecr.tf               # Elastic Container Registry
    ├── ecs.tf               # ECS Fargate (cluster, task, service)
    ├── rds.tf               # RDS MySQL e Security Groups
    ├── lambda.tf            # Lambda function para processamento de vídeos
    ├── locals.tf            # Variáveis locais
    ├── versions.tf          # Versões do Terraform e providers
    └── terraform.tfvars.example  # Exemplo de variáveis
```

## 🔧 Variáveis Disponíveis

| Variável | Descrição | Padrão |
|----------|-----------|--------|
| `aws_region` | Região AWS para deploy | `us-east-1` |
| `environment` | Nome do ambiente (dev/staging/prod) | `dev` |

## 🔐 Boas Práticas

- Nunca commitar `terraform.tfvars` com valores sensíveis
- Use workspaces do Terraform para ambientes diferentes
- Mantenha o estado remoto habilitado em produção
- Revise sempre o `terraform plan` antes de aplicar
- Use tags consistentes em todos os recursos

## 🚀 CI/CD com GitHub Actions

Este repositório possui workflow automatizado para deploy da infraestrutura.

### Configuração Inicial

1. Configure os secrets no GitHub:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_SESSION_TOKEN` (se usar AWS Academy)

2. O workflow roda automaticamente em push para `main` com mudanças em `terraform/**`

3. Também pode ser executado manualmente via Actions tab

### Documentação Completa

📖 **Veja:** [DEPLOYMENT.md](DEPLOYMENT.md) para guia completo de deploy via GitHub Actions

### Outputs do Deploy

Após o deploy, o workflow exibe os outputs necessários para configurar o repositório [video-core](https://github.com/fiap-software-architecture-tech/video-core):
- ECR Repository URL
- ECR Repository Name
- ECS Cluster Name
- ECS Service Name

## 🧹 Destruir recursos

Para remover todos os recursos criados:

```bash
terraform destroy
```

**⚠️ CUIDADO:** Isso removerá permanentemente todos os recursos, incluindo buckets e dados

## 🔗 Repositórios Relacionados

- **Aplicação**: [video-core](https://github.com/fiap-software-architecture-tech/video-core) - Aplicação Node.js
- **Infraestrutura**: video-infra (este repositório) - Provisionamento AWS
