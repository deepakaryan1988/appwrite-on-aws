output "appwrite_env_secret_arn" {
  value = aws_secretsmanager_secret.appwrite_env.arn
} 