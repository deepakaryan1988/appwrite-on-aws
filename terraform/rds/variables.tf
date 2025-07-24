variable "db_name" {
  description = "Name of the RDS database"
  type        = string
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC ID for the RDS subnet group"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for RDS subnet group"
  type        = list(string)
}

variable "rds_sg_id" {
  description = "Security Group ID to allow access to RDS"
  type        = string
}
