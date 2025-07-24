output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "rds_sg_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds_sg.id
}
