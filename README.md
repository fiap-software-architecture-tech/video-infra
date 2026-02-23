# video-infra

Repositório responsável pela definição, provisionamento e orquestração da infraestrutura da plataforma de processamento de vídeos.

## 📌 Visão Geral

O **video-infra** centraliza todos os artefatos necessários para subir e operar o ecossistema de microsserviços da aplicação. Seu objetivo é garantir padronização de ambientes, reprodutibilidade de deploys e suporte à escalabilidade da solução.

Este repositório não contém lógica de negócio — apenas configurações de infraestrutura e automação.

## 🚀 Responsabilidades

- Orquestração de containers (Docker / Docker Compose / Kubernetes)
- Provisionamento de mensageria (RabbitMQ ou Kafka)
- Configuração de banco de dados e cache (ex: PostgreSQL, Redis)
- Setup de observabilidade (logs, métricas e monitoramento)
- Suporte a pipelines de CI/CD
- Padronização de variáveis de ambiente e redes
- Scripts de bootstrap do ambiente

## 🧱 Serviços Suportados

Este repositório dá suporte aos seguintes microsserviços:

- video-auth-service
- video-processing-service

## ⚙️ Como subir o ambiente (exemplo)

```bash
docker compose up -d
