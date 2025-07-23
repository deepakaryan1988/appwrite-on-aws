resource "aws_ecr_repository" "appwrite" {
  name = "${var.project}-appwrite"
}

resource "aws_ecr_repository" "redis" {
  name = "${var.project}-redis"
}

resource "aws_ecr_repository" "mongodb" {
  name = "${var.project}-mongodb"
}
