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
  engine_version       = "6.x"
  node_type            = var.node_type
  num_cache_nodes      = 1
  parameter_group_name = var.parameter_group_name
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
  security_group_ids   = [aws_security_group.redis.id]

  tags = {
    Name = "${var.project}-redis"
  }
} 