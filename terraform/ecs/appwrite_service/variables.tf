variable "project" {}
variable "ecs_cluster_id" {}
variable "task_definition_arn" {}

variable "subnet_ids" {
  type = list(string)
}
variable "security_group_ids" {
  type = list(string)
}

variable "alb_target_group_arn" {}
variable "alb_listener_arn" {}

variable "alb_arn" {}

variable "desired_count" {
  default = 1
}
