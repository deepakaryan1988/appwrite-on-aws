resource "aws_secretsmanager_secret" "appwrite_env" {
  name = "${var.project}-appwrite-env-v3"
}

resource "aws_secretsmanager_secret_version" "env_values" {
  secret_id     = aws_secretsmanager_secret.appwrite_env.id
  secret_string = jsonencode(var.env_vars)
}
