# 🚀 Deployment Workflow

Este repositório contém a infraestrutura AWS usando Terraform e o GitHub Actions workflow para deploy automático.

## 📋 Estrutura

```
video-infra/
├── terraform/              # Terraform configuration
│   ├── *.tf               # Infrastructure as Code
│   └── ...
└── .github/
    └── workflows/
        └── deploy-infra.yml  # CI/CD workflow
```

## 🔄 Fluxo de Deploy

### 1. **Trigger do Workflow**

O workflow é acionado automaticamente quando:
- ✅ Push para branch `main` com mudanças em `terraform/**`
- ✅ Execução manual via Actions tab

### 2. **Etapas do Deploy**

```mermaid
graph LR
    A[Push/Manual] --> B[Checkout Code]
    B --> C[Configure AWS]
    C --> D[Terraform Init]
    D --> E[Terraform Plan]
    E --> F[Terraform Apply]
    F --> G[Get Outputs]
    G --> H[Display Summary]
    H --> I[Save Artifact]
```

### 3. **Terraform Outputs**

O workflow exporta os seguintes valores:
- `ECR_REPOSITORY_URL` - URL completa do repositório ECR
- `ECR_REPOSITORY_NAME` - Nome do repositório ECR
- `ECS_CLUSTER_NAME` - Nome do cluster ECS
- `ECS_SERVICE_NAME` - Nome do serviço ECS

Estes valores são necessários para o deploy da aplicação no repositório [video-core](https://github.com/fiap-software-architecture-tech/video-core).

## 🎯 Como Usar

### Deploy Automático (Push)

```bash
# 1. Faça alterações no Terraform
cd terraform
vim ecr.tf  # ou qualquer arquivo .tf

# 2. Commit e push
git add .
git commit -m "feat: update infrastructure"
git push origin main

# 3. Aguarde o workflow concluir
# GitHub Actions → Deploy Infrastructure
```

### Deploy Manual

1. Acesse: [Actions → Deploy Infrastructure](https://github.com/fiap-software-architecture-tech/video-infra/actions/workflows/deploy-infra.yml)
2. Clique em "Run workflow"
3. Selecione a branch `main`
4. Clique em "Run workflow"

### Após o Deploy

O workflow exibirá um **summary** com os outputs do Terraform:

```
✅ Infrastructure deployed successfully!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Use these values to deploy the application:

📦 ECR Repository URL:
   123456789012.dkr.ecr.us-east-1.amazonaws.com/video-core-image

🏷️  ECR Repository Name:
   video-core-image

🎯 ECS Cluster Name:
   video-core-cluster-dev

🚀 ECS Service Name:
   video-core-service-dev
```

**📝 Copie estes valores!** Você precisará deles para:

#### Opção 1: Deploy Manual no video-core
1. Vá para: [video-core → Actions → Deploy Application](https://github.com/fiap-software-architecture-tech/video-core/actions/workflows/deploy-app.yml)
2. Clique em "Run workflow"
3. Cole os valores nos campos correspondentes
4. Execute o workflow

#### Opção 2: Configurar Deploy Automático no video-core
1. Vá para: [video-core → Settings → Secrets and variables → Actions → Variables](https://github.com/fiap-software-architecture-tech/video-core/settings/variables/actions)
2. Adicione as seguintes **Repository Variables**:
   - `ECR_REPOSITORY_URL`
   - `ECR_REPOSITORY_NAME`
   - `ECS_CLUSTER_NAME`
   - `ECS_SERVICE_NAME`
3. A partir de agora, pushes no `video-core` farão deploy automaticamente

## 🔐 Secrets Necessários

Configure em: [Settings → Secrets and variables → Actions](https://github.com/fiap-software-architecture-tech/video-infra/settings/secrets/actions)

**Repository Secrets:**
- `AWS_ACCESS_KEY_ID` - AWS Access Key
- `AWS_SECRET_ACCESS_KEY` - AWS Secret Access Key
- `AWS_SESSION_TOKEN` - AWS Session Token (para AWS Academy)

## 📊 Monitoramento

- **Workflow Logs**: GitHub Actions → Deploy Infrastructure
- **Terraform State**: AWS S3 (configurado no backend)
- **AWS Console**: [ECS Clusters](https://console.aws.amazon.com/ecs/v2/clusters)

## 🛠️ Troubleshooting

### Erro: "Error acquiring the state lock"
Outro deploy está em andamento. Aguarde ou force unlock:
```bash
cd terraform
terraform force-unlock <LOCK_ID>
```

### Erro: "InvalidParameterException: No such repository"
O ECR ainda não foi criado. Execute o workflow pela primeira vez.

### Erro: "AccessDeniedException"
Verifique:
1. ✅ Secrets AWS configurados
2. ✅ LabRole tem permissões necessárias
3. ✅ Session token não expirou (AWS Academy)

## 📚 Recursos

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)

---

## 🔗 Repositórios Relacionados

- **Aplicação**: [video-core](https://github.com/fiap-software-architecture-tech/video-core)
- **Infraestrutura**: video-infra (este repositório)
