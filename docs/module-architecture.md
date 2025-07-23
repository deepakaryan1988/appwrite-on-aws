# 🧱 Terraform Module Architecture – Appwrite on AWS

A high-level view of how the infrastructure modules interact with each other.

```plaintext
infra/main.tf
├── module "network" → VPC + public subnets + IGW
│     └── exports: vpc_id, public_subnet_ids
│
├── module "alb"
│     └── uses: module.network.vpc_id, module.network.public_subnet_ids
│
├── module "cloudwatch" → creates log group
│
├── module "ecs_cluster" → ECS Fargate cluster
│
├── module "secrets" → SecretsManager + version
│     └── creates: appwrite-devops-appwrite-env
│
├── module "iam" → Task Role + Exec Role
│
├── module "ecs_appwrite"
│     └── uses:
│           - container_image: appwrite/appwrite:1.5.4
│           - log_group
│           - secret ARNs via data source (clean method ✅)
│           - IAM roles
