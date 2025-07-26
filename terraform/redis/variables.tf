variable "vpc_id" {
  description = "VPC ID for Redis deployment"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for Redis subnet group"
  type        = list(string)
}

variable "project" {
  description = "Project name or prefix"
  type        = string
}

variable "ecs_sg_id" {
  description = "ECS task security group ID allowed to access Redis"
  type        = string
}

variable "node_type" {
  description = "Instance type for Redis nodes"
  type        = string
  default     = "cache.t3.micro"
}

variable "parameter_group_name" {
  description = "Redis parameter group name"
  type        = string
  default     = "default.redis7"
} 