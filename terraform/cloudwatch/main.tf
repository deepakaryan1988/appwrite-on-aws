resource "aws_cloudwatch_log_group" "appwrite" {
  name              = "/ecs/appwrite"
  retention_in_days = 7
}
