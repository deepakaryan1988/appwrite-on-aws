resource "aws_ecs_cluster" "this" {
  name = "${var.project}-cluster"
}
