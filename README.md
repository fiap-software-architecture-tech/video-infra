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
  - video-events (fila principal)
  - video-events-dlq (dead letter queue)

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
    ├── s3.tf                # Recursos S3 (buckets)
    ├── sqs.tf               # Recursos SQS (filas)
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

## 🧹 Destruir recursos

Para remover todos os recursos criados:

```bash
terraform destroy
```

**⚠️ CUIDADO:** Isso removerá permanentemente todos os recursos, incluindo buckets e dados
