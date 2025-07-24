# 🧱 Terraform Module Architecture – Appwrite on AWS

A high-level view of how the infrastructure modules interact with each other, including dynamic Redis integration.

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
├── module "redis" → ElastiCache Redis 6.x
│     └── uses: module.network.vpc_id, module.network.public_subnet_ids, module.alb.service_sg_id (for ECS access)
│     └── exports: redis_endpoint, redis_sg_id
│
├── module "secrets" → SecretsManager + version
│     └── creates: appwrite-devops-appwrite-env
│     └── injects: dynamic values (e.g., Redis endpoint) from other modules
│
├── module "iam" → Task Role + Exec Role
│
├── module "ecs_appwrite"
│     └── uses:
│           - container_image: appwrite/appwrite:1.5.4
│           - log_group
│           - secret ARNs via data source (dynamic, e.g., Redis endpoint)
│           - IAM roles
```

**Highlights:**
- Redis is provisioned via a dedicated module with its own security group, allowing access only from ECS tasks.
- The Redis endpoint is dynamically injected into AWS Secrets Manager, ensuring ECS always receives the correct value.
- No hardcoded secrets or endpoints; all values are managed and updated by Terraform modules.
