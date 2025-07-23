provider "aws" {
  region = var.aws_region
}

module "network" {
  source     = "../terraform/network"
  aws_region = var.aws_region
  project    = var.project
}

module "ecr" {
  source     = "../terraform/ecr"
  aws_region = var.aws_region
  project    = var.project
}

module "secrets" {
  source     = "../terraform/secrets"
  project    = var.project
  env_vars   = {
    APPWRITE_DB_HOST             = "mongodb.internal"      # We'll later override with service DNS
    APPWRITE_REDIS_HOST          = "redis.internal"         # Same
    APPWRITE_PROJECTS_STATS      = "enabled"
    APPWRITE_USAGE_STATS         = "enabled"
    APPWRITE_FUNCTIONS_ENV       = "node-18.0"
    APPWRITE_FUNCTIONS_TIMEOUT   = "60"
    APPWRITE_HOSTNAME            = "appwrite.local"         # Use real domain later
  }
}
