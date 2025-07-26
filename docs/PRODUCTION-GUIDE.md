# 🚀 Production Deployment Guide - Appwrite on AWS

This guide provides production-ready deployment instructions for Appwrite on AWS using Terraform with enterprise-grade security and best practices.

## 📋 Prerequisites

### Required Tools
- **Terraform** >= 1.0
- **AWS CLI** >= 2.0 (configured with appropriate credentials)
- **Domain name** (optional, for HTTPS)
- **ACM Certificate** (optional, for HTTPS)

### AWS Permissions
Your AWS credentials need the following services permissions:
- VPC, Subnets, Internet Gateways, NAT Gateways
- ECS, ELB, ALB, Target Groups
- RDS, ElastiCache
- Secrets Manager, IAM
- CloudWatch, ECR

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐
│   Public Subnet │    │   Public Subnet │
│     (ALB)       │    │   (NAT Gateway) │
└─────────────────┘    └─────────────────┘
         │                       │
┌─────────────────┐    ┌─────────────────┐
│  Private Subnet │    │  Private Subnet │
│ ECS, RDS, Redis │    │ ECS, RDS, Redis │
└─────────────────┘    └─────────────────┘
```

### Key Features
- ✅ **Private Networking**: RDS, Redis, and ECS in private subnets
- ✅ **High Availability**: Multi-AZ deployment
- ✅ **Security**: Encryption at rest, IAM roles, Security Groups
- ✅ **Monitoring**: CloudWatch logs and metrics
- ✅ **Scalability**: Auto-scaling capable architecture
- ✅ **Backup**: Automated RDS backups and Redis snapshots

## 🔧 Production Configuration

### 1. Clone and Prepare
```bash
git clone https://github.com/deepakaryan1988/appwrite-on-aws.git
cd appwrite-on-aws/infra
```

### 2. Configure Variables
```bash
cp terraform.tfvars.example terraform.tfvars
```

**Edit terraform.tfvars** with your production values:
```hcl
# Essential Configuration
aws_region = "us-east-1"
project    = "appwrite-prod"
appwrite_hostname = "appwrite.yourdomain.com"

# Production Sizing
ecs_cpu           = "1024"    # 1 vCPU
ecs_memory        = "2048"    # 2GB RAM
redis_node_type   = "cache.t3.small"
rds_instance_type = "db.t3.small"

# Database (Use strong credentials!)
db_password = "YourSecurePassword123!"
```

### 3. Deploy Infrastructure
```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Deploy (takes ~15 minutes)
terraform apply
```

## 🛡️ Security Best Practices

### ✅ Implemented Security Features

1. **Network Security**
   - Private subnets for all data services
   - NAT Gateways for secure internet access
   - Security Groups with least privilege

2. **Data Encryption**
   - RDS encryption at rest enabled
   - Redis encryption at rest enabled
   - Secrets Manager for sensitive data

3. **Access Control**
   - IAM roles with minimal permissions
   - No public database access
   - VPC endpoints for AWS services

4. **Monitoring & Backup**
   - CloudWatch logging enabled
   - RDS automated backups (7 days)
   - Redis snapshots (5 days)
   - Deletion protection enabled

### 🔒 Additional Security Recommendations

1. **Enable HTTPS**
   ```hcl
   acm_certificate_arn = "arn:aws:acm:region:account:certificate/cert-id"
   ```

2. **Database Security**
   - Use AWS Secrets Manager for DB credentials
   - Enable RDS Performance Insights
   - Configure VPC Flow Logs

3. **Application Security**
   - Regular container image updates
   - WAF configuration for ALB
   - API rate limiting

## 📊 Monitoring & Maintenance

### CloudWatch Dashboards
- **ECS Metrics**: CPU, Memory, Task count
- **RDS Metrics**: Connections, CPU, Storage
- **Redis Metrics**: CPU, Memory, Connections
- **ALB Metrics**: Request count, Response time

### Log Locations
- **Application Logs**: `/ecs/appwrite`
- **Redis Logs**: `/aws/elasticache/redis/PROJECT_NAME`

### Backup Strategy
- **RDS**: Automated backups (7 days) + manual snapshots
- **Redis**: Automated snapshots (5 days)
- **Infrastructure**: Terraform state in S3 with versioning

## 🔄 Updates & Maintenance

### Application Updates
```bash
# Update container image version
terraform apply -var="appwrite_image=appwrite/appwrite:1.6.1"
```

### Infrastructure Updates
```bash
# Scale ECS resources
terraform apply -var="ecs_cpu=2048" -var="ecs_memory=4096"
```

### Database Maintenance
- Maintenance windows: Sundays 04:00-05:00 UTC
- Backup windows: Daily 03:00-04:00 UTC
- Auto minor version upgrades enabled

## 🚨 Troubleshooting

### Common Issues

1. **ECS Tasks Not Starting**
   ```bash
   aws ecs describe-services --cluster CLUSTER_NAME --services SERVICE_NAME
   aws logs get-log-events --log-group-name /ecs/appwrite
   ```

2. **Database Connection Issues**
   - Verify security groups allow port 3306
   - Check RDS endpoint in Secrets Manager
   - Confirm private subnet routing

3. **Redis Connection Issues**
   - Verify security groups allow port 6379
   - Check Redis endpoint configuration
   - Confirm private DNS resolution

### Health Checks
```bash
# Check application health
curl http://ALB_DNS_NAME/v1/health

# Check ECS service status
aws ecs describe-services --cluster appwrite-prod-cluster --services appwrite-prod-service
```

## 💰 Cost Optimization

### Production Cost Estimates (us-east-1)
- **ECS Fargate**: ~$35/month (1 vCPU, 2GB)
- **RDS t3.small**: ~$25/month
- **Redis t3.micro**: ~$15/month
- **ALB**: ~$20/month
- **NAT Gateway**: ~$45/month
- **Total**: ~$140/month

### Cost Savings Tips
1. Use Reserved Instances for RDS
2. Schedule ECS tasks for non-production
3. Implement lifecycle policies for logs
4. Use S3 for static assets

## 🔗 Useful Commands

```bash
# Get application URL
terraform output application_url

# Get database endpoint (sensitive)
terraform output database_endpoint

# Scale ECS service
aws ecs update-service --cluster CLUSTER --service SERVICE --desired-count 2

# View application logs
aws logs tail /ecs/appwrite --follow
```

## 📞 Support

For issues related to:
- **Infrastructure**: Check CloudWatch logs and ECS service events
- **Application**: Refer to [Appwrite Documentation](https://appwrite.io/docs)
- **AWS Resources**: Use AWS Support or documentation

---

**⚠️ Remember**: This is a production deployment. Always test changes in a development environment first!