resource "aws_ecs_task_definition" "appwrite" {
  family                   = "${var.project}-appwrite"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name  = "appwrite"
      image = var.container_image
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "appwrite"
        }
      }

      secrets = [
        for key, value in var.env_secrets : {
          name      = key
          valueFrom = value
        }
      ]
    }
  ])
}
