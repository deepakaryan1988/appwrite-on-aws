variable "aws_region" {
  default = "ap-south-1"
}

variable "project" {
  default = "appwrite-devops"
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]  # Two AZs
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
}

