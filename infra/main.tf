provider "aws" {
  region = var.aws_region
}

module "network" {
  source               = "../terraform/network"
  aws_region           = var.aws_region
  project              = var.project
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  ecs_sg_id            = module.alb.service_sg_id
}


module "ecr" {
  source     = "../terraform/ecr"
  aws_region = var.aws_region
  project    = var.project
}

module "redis" {
  source     = "../terraform/redis"
  project    = var.project
  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.private_subnet_ids
  ecs_sg_id  = module.alb.service_sg_id
  node_type  = var.redis_node_type
}

module "secrets" {
  source     = "../terraform/secrets"
  project    = var.project
  env_vars = merge(
    {
      APPWRITE_REDIS_HOST = module.redis.redis_endpoint
      APPWRITE_HOSTNAME   = var.appwrite_hostname
      APPWRITE_DB_HOST    = module.rds.db_endpoint
    },
    var.env_vars
  )
  depends_on = [module.redis, module.rds]
}

# Outputs for external access and monitoring
output "application_url" {
  description = "Application Load Balancer URL"
  value       = "http://${module.alb.alb_dns_name}"
}

output "appwrite_env_secret_arn" {
  description = "ARN of the Secrets Manager secret containing environment variables"
  value       = module.secrets.appwrite_env_secret_arn
  sensitive   = true
}

output "redis_endpoint" {
  description = "Redis cluster endpoint"
  value       = module.redis.redis_endpoint
  sensitive   = true
}

output "database_endpoint" {
  description = "RDS database endpoint"
  value       = module.rds.db_endpoint
  sensitive   = true
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.network.private_subnet_ids
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.network.public_subnet_ids
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs_cluster.cluster_name
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = module.ecs_appwrite_service.ecs_service_name
}

module "ecs_cluster" {
  source  = "../terraform/ecs/cluster"
  project = var.project
}

module "cloudwatch" {
  source  = "../terraform/cloudwatch"
  project = var.project
}

module "alb" {
  source             = "../terraform/alb"
  project            = var.project
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
}

module "ecs_appwrite" {
  source = "../terraform/ecs/appwrite"
  aws_region = var.aws_region
  project    = var.project

  container_image      = var.appwrite_image
  log_group            = "/ecs/appwrite"
  cpu                  = var.ecs_cpu
  memory               = var.ecs_memory
  execution_role_arn   = module.iam.execution_role_arn
  task_role_arn        = module.iam.task_role_arn
  alb_arn              = module.alb.alb_arn

  env_secrets = {
    _APP_ENV                  = "${module.secrets.appwrite_env_secret_arn}:_APP_ENV::"
    _APP_OPENSSL_KEY_V1       = "${module.secrets.appwrite_env_secret_arn}:_APP_OPENSSL_KEY_V1::"
    _APP_DB_ROOT_PASS         = "${module.secrets.appwrite_env_secret_arn}:_APP_DB_ROOT_PASS::"
    _APP_DB_HOST              = "${module.secrets.appwrite_env_secret_arn}:_APP_DB_HOST::"
    _APP_DB_USER              = "${module.secrets.appwrite_env_secret_arn}:_APP_DB_USER::"
    _APP_DB_PASS              = "${module.secrets.appwrite_env_secret_arn}:_APP_DB_PASS::"
    _APP_DB_SCHEMA            = "${module.secrets.appwrite_env_secret_arn}:_APP_DB_SCHEMA::"
    _APP_REDIS_HOST           = "${module.secrets.appwrite_env_secret_arn}:_APP_REDIS_HOST::"
    _APP_REDIS_PORT           = "${module.secrets.appwrite_env_secret_arn}:_APP_REDIS_PORT::"
    _APP_SYSTEM_EMAIL_NAME    = "${module.secrets.appwrite_env_secret_arn}:_APP_SYSTEM_EMAIL_NAME::"
    _APP_SYSTEM_EMAIL_ADDRESS = "${module.secrets.appwrite_env_secret_arn}:_APP_SYSTEM_EMAIL_ADDRESS::"
    _APP_SYSTEM_SERVER_HOST   = "${module.secrets.appwrite_env_secret_arn}:_APP_SYSTEM_SERVER_HOST::"
    APPWRITE_PROJECTS_STATS   = "${module.secrets.appwrite_env_secret_arn}:APPWRITE_PROJECTS_STATS::"
    APPWRITE_USAGE_STATS      = "${module.secrets.appwrite_env_secret_arn}:APPWRITE_USAGE_STATS::"
    APPWRITE_FUNCTIONS_ENV    = "${module.secrets.appwrite_env_secret_arn}:APPWRITE_FUNCTIONS_ENV::"
    APPWRITE_FUNCTIONS_TIMEOUT = "${module.secrets.appwrite_env_secret_arn}:APPWRITE_FUNCTIONS_TIMEOUT::"
  }

}

module "iam" {
  source  = "../terraform/iam"
  project = var.project
  appwrite_env_secret_arn = module.secrets.appwrite_env_secret_arn
}

module "ecs_appwrite_service" {
  source = "../terraform/ecs/appwrite_service"

  project              = var.project
  ecs_cluster_id       = module.ecs_cluster.cluster_id
  task_definition_arn  = module.ecs_appwrite.task_definition_arn

  subnet_ids           = module.network.private_subnet_ids
  security_group_ids   = [module.alb.service_sg_id]

  alb_target_group_arn = module.alb.target_group_arn
  alb_listener_arn     = module.alb.listener_arn
  alb_arn              = module.alb.alb_arn

  desired_count        = 1
}

module "rds" {
  source = "../terraform/rds"

  db_name          = var.db_name
  db_username      = var.db_username
  db_password      = var.db_password
  instance_class   = var.rds_instance_type

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.private_subnet_ids
  rds_sg_id  = module.network.rds_sg_id
  monitoring_role_arn = "arn:aws:iam::442740305597:role/rds-monitoring-role"
}
