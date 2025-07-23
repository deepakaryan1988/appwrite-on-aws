provider "aws" {
  region = var.aws_region
}

module "network" {
  source              = "../terraform/network"
  aws_region          = var.aws_region
  project             = var.project
  public_subnet_cidrs = var.public_subnet_cidrs
}


module "ecr" {
  source     = "../terraform/ecr"
  aws_region = var.aws_region
  project    = var.project
}

module "secrets" {
  source     = "../terraform/secrets"
  project    = var.project
  env_vars = var.env_vars
}

data "aws_secretsmanager_secret" "appwrite_env" {
  name = "${var.project}-appwrite-env"
}

output "appwrite_env_secret_arn" {
  value = data.aws_secretsmanager_secret.appwrite_env.arn
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

  container_image     = "appwrite/appwrite:1.5.4"
  log_group           = "/ecs/appwrite"
  cpu                 = "512"
  memory              = "1024"
  execution_role_arn  = module.iam.execution_role_arn     # coming soon
  task_role_arn       = module.iam.task_role_arn          # coming soon

  env_secrets = {
    APPWRITE_DB_HOST           = "${data.aws_secretsmanager_secret.appwrite_env.arn}:APPWRITE_DB_HOST::"
    APPWRITE_REDIS_HOST        = "${data.aws_secretsmanager_secret.appwrite_env.arn}:APPWRITE_REDIS_HOST::"
    APPWRITE_PROJECTS_STATS    = "${data.aws_secretsmanager_secret.appwrite_env.arn}:APPWRITE_PROJECTS_STATS::"
    APPWRITE_USAGE_STATS       = "${data.aws_secretsmanager_secret.appwrite_env.arn}:APPWRITE_USAGE_STATS::"
    APPWRITE_FUNCTIONS_ENV     = "${data.aws_secretsmanager_secret.appwrite_env.arn}:APPWRITE_FUNCTIONS_ENV::"
    APPWRITE_FUNCTIONS_TIMEOUT = "${data.aws_secretsmanager_secret.appwrite_env.arn}:APPWRITE_FUNCTIONS_TIMEOUT::"
    APPWRITE_HOSTNAME          = "${data.aws_secretsmanager_secret.appwrite_env.arn}:APPWRITE_HOSTNAME::"
  }

}

module "iam" {
  source  = "../terraform/iam"
  project = var.project
}

