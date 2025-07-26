resource "aws_secretsmanager_secret" "appwrite_env" {
  name        = "${var.project}-appwrite-env-new"
  description = "Appwrite environment variables"
}

resource "aws_secretsmanager_secret_version" "appwrite_env" {
  secret_id     = aws_secretsmanager_secret.appwrite_env.id
  secret_string = jsonencode(var.env_vars)
} 