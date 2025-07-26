resource "aws_security_group" "redis" {
  name        = "${var.project}-redis-sg"
  description = "Allow Redis access from ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port                = 6379
    to_port                  = 6379
    protocol                 = "tcp"
    security_groups          = [var.ecs_sg_id]
    description              = "Allow Redis from ECS tasks"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-redis-sg"
  }
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.project}-redis-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.project}-redis"
  engine               = "redis"
  engine_version       = "7.0"
  node_type            = var.node_type
  num_cache_nodes      = 1
  parameter_group_name = var.parameter_group_name
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
  security_group_ids   = [aws_security_group.redis.id]
  
  # Security settings
  az_mode = "single-az"
  
  # Maintenance and backup
  maintenance_window       = "sun:05:00-sun:06:00"
  snapshot_retention_limit = 5
  snapshot_window         = "03:00-05:00"
  
  # Enable logging for troubleshooting
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.redis.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }

  tags = {
    Name = "${var.project}-redis"
    Environment = "production"
  }
}

# CloudWatch Log Group for Redis
resource "aws_cloudwatch_log_group" "redis" {
  name              = "/aws/elasticache/redis/${var.project}"
  retention_in_days = 7

  tags = {
    Name = "${var.project}-redis-logs"
  }
} 