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
      name      = "appwrite"
      image     = var.container_image
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]

      # Health check
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost/v1/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }

      # Resource limits
      memoryReservation = floor(tonumber(var.memory) * 0.8)
      
      # Security
      readonlyRootFilesystem = false  # Appwrite needs write access
      user = "1000:1000"  # Run as non-root user

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
      
      # Environment variables that don't need to be secret
      environment = [
        {
          name  = "APPWRITE_WORKER_PER_CORE"
          value = "6"
        },
        {
          name  = "APPWRITE_LOGGING_PROVIDER"
          value = "stdout"
        }
      ]
    }
  ])
}
