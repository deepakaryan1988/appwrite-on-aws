resource "aws_cloudwatch_log_group" "appwrite" {
  name              = "/ecs/appwrite"
  retention_in_days = 30  # Increased for production
  
  tags = {
    Name = "Appwrite ECS Logs"
    Environment = "production"
  }
}
