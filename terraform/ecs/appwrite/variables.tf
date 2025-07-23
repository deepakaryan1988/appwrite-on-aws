variable "aws_region" {}
variable "project" {}

variable "cpu" {
  default = "512"
}
variable "memory" {
  default = "1024"
}

variable "container_image" {}  # e.g. appwrite/appwrite:1.5.4

variable "log_group" {}

variable "execution_role_arn" {}
variable "task_role_arn" {}

variable "env_secrets" {
  type = map(string)
  description = "Map of environment variable name → Secrets Manager ARN"
}
