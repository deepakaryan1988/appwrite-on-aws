resource "aws_db_subnet_group" "this" {
  name       = "appwrite-rds-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "Appwrite RDS Subnet Group"
  }
}

resource "aws_db_instance" "this" {
  identifier         = "appwrite-db"
  allocated_storage  = 20
  max_allocated_storage = 100
  engine             = "mysql"
  engine_version     = "8.0"
  instance_class     = var.instance_class
  db_name            = var.db_name
  username           = var.db_username
  password           = var.db_password
  
  # Security settings
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.rds_sg_id]
  publicly_accessible    = false  # SECURITY: Keep RDS private
  
  # Backup and maintenance
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Sun:04:00-Sun:05:00"
  skip_final_snapshot    = false
  final_snapshot_identifier = "appwrite-db-final-snapshot"
  
  # Encryption
  storage_encrypted = true
  
  # Monitoring
  performance_insights_enabled = false  # Not supported on t3.micro
  monitoring_interval         = 60
  monitoring_role_arn         = var.monitoring_role_arn
  
  # Deletion protection for production
  deletion_protection = true

  tags = {
    Name = "Appwrite MySQL"
    Environment = "production"
  }
}
