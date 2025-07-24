resource "aws_lb_listener" "http" {
  load_balancer_arn = var.alb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.alb_target_group_arn
  }
}

resource "aws_ecs_service" "appwrite" {
  name            = "${var.project}-service"
  cluster         = var.ecs_cluster_id
  task_definition = var.task_definition_arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "appwrite"
    container_port   = 80
  }

  health_check_grace_period_seconds = 120

  depends_on = [var.alb_listener_arn]
}
