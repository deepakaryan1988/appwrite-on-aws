variable "project" {
  description = "Project prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC where ALB will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnets for ALB"
  type        = list(string)
}
