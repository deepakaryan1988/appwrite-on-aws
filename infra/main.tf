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
