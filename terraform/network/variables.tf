variable "aws_region" {}
variable "project" {}
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "Security group ID of the ECS tasks that need DB access"
  type        = string
}
