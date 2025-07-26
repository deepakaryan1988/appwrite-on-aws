variable "aws_region" {
  default = "ap-south-1"
}

variable "project" {
  default = "appwrite-devops"
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]  # Two AZs for ALB
}

variable "private_subnet_cidrs" {
  type = list(string)
  default = ["10.0.10.0/24", "10.0.20.0/24"]  # Two AZs for Redis/RDS/ECS
}

variable "db_name" {
  type        = string
  description = "Name of the RDS database"
}

variable "db_username" {
  type        = string
  description = "Master username for RDS"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "Master password for RDS"
  sensitive   = true
}
variable "env_vars" {
  type        = map(string)
  description = "Environment variables to inject into Appwrite container"
  default     = {
    APPWRITE_PROJECTS_STATS    = "enabled"
    APPWRITE_USAGE_STATS       = "enabled"  
    APPWRITE_FUNCTIONS_ENV     = "production"
    APPWRITE_FUNCTIONS_TIMEOUT = "900"
  }
}

variable "appwrite_hostname" {
  type        = string
  description = "Hostname for Appwrite instance"
  default     = "appwrite.local"
}

variable "acm_certificate_arn" {
  type        = string
  description = "ACM certificate ARN for HTTPS"
  default     = ""
}

variable "appwrite_image" {
  type        = string
  description = "Appwrite container image and tag"
  default     = "appwrite/appwrite:1.6.0"
}

variable "ecs_cpu" {
  type        = string
  description = "CPU units for ECS task (256, 512, 1024, 2048, 4096)"
  default     = "512"
  
  validation {
    condition     = contains(["256", "512", "1024", "2048", "4096"], var.ecs_cpu)
    error_message = "ECS CPU must be one of: 256, 512, 1024, 2048, 4096."
  }
}

variable "ecs_memory" {
  type        = string
  description = "Memory for ECS task in MB"
  default     = "1024"
  
  validation {
    condition = contains([
      "512", "1024", "2048", "3072", "4096", "5120", "6144", "7168", "8192",
      "9216", "10240", "11264", "12288", "13312", "14336", "15360", "16384"
    ], var.ecs_memory)
    error_message = "ECS memory must be a valid value for the selected CPU."
  }
}

variable "redis_node_type" {
  type        = string
  description = "Redis node instance type"
  default     = "cache.t3.micro"
}

variable "rds_instance_type" {
  type        = string
  description = "RDS instance type"
  default     = "db.t3.micro"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  default     = "prod"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags to apply to all resources"
  default = {
    Project     = "Appwrite"
    Environment = "production"
    ManagedBy   = "Terraform"
    Owner       = "DevOps"
  }
}

