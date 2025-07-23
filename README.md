# 🧱 Appwrite on AWS (Terraform + Fargate)

## 📝 Description
This project provisions a fully modular, production-grade infrastructure on AWS to deploy [Appwrite](https://appwrite.io/) using ECS Fargate, ECR, Secrets Manager, IAM, and Terraform.

The goal is to provide a repeatable and cost-efficient way to spin up and tear down the Appwrite stack using a single command via the `infra/` folder.

---

## 📦 Current Setup

- **Modular Terraform layout**
- `infra/` folder to control the full lifecycle
- **VPC + subnets** (via `network` module)
- **ECR** (via `ecr` module)
- **Secrets Manager** for ENV injection (via `secrets` module)
- **IAM roles** for ECS execution and task role (via `iam` module)
- **ECS Task Definition** for Appwrite with injected secrets
- **Dynamic secret resolution** using `data "aws_secretsmanager_secret"`
- **GitHub repo:** [https://github.com/deepakaryan1988/appwrite-on-aws](https://github.com/deepakaryan1988/appwrite-on-aws)

---

## ✅ Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/deepakaryan1988/appwrite-on-aws.git
   cd appwrite-on-aws
   ```
2. **Create your own secrets file:**
   ```bash
   cp secrets.auto.tfvars.example secrets.auto.tfvars
   # Update the secret values in secrets.auto.tfvars
   ```
3. **Initialize and apply Terraform:**
   ```bash
   cd infra/
   terraform init
   terraform apply
   ```

---

## 📁 Folder Structure

- `infra/` – Master Terraform controller
- `terraform/network/` – VPC and subnets
- `terraform/ecr/` – ECR repo for Appwrite image (if custom build)
- `terraform/secrets/` – Secrets Manager integration
- `terraform/iam/` – IAM roles and policies
- `terraform/ecs/appwrite/` – ECS Task Definition for Appwrite

---

## 🚀 Coming Next

- ECS Cluster setup
- ECS Service + ALB + Target Group for Appwrite
- Persistent storage with EFS (optional)
- CI/CD pipeline via GitHub Actions
- CloudWatch log group for /ecs/appwrite
- Domain setup and HTTPS (via Route 53 + ACM)

---

## 📄 License
This project is licensed under the MIT License.

---

## 👨‍💻 Author
**Deepak Kumar**

- [GitHub](https://github.com/deepakaryan1988)
- [LinkedIn](https://www.linkedin.com/in/deepakaryan1988/)
- [Drupal](https://www.drupal.org/u/deepakaryan1988)

---

## 🌐 Our Blog
Check out our technical blog on Hashnode: [debugdeploygrow.hashnode.dev](https://debugdeploygrow.hashnode.dev)
