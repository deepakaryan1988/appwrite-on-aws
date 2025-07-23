variable "aws_region" {
  default = "ap-south-1"
}

variable "project" {
  default = "appwrite-devops"
}

variable "env_vars" {
  type = map(string)
}
