output "db_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_name" {
  value = var.db_name
}
