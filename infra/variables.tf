variable "aws_region" {
  default = "ap-south-1"
}

variable "project" {
  default = "appwrite-devops"
}

variable "env_vars" {
  type = map(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]  # Two AZs
}
