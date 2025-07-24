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
  engine             = "mysql"
  engine_version     = "8.0"
  instance_class     = "db.t3.micro"
  db_name            = var.db_name
  username           = var.db_username
  password           = var.db_password
  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.rds_sg_id]
  skip_final_snapshot = true
  publicly_accessible = true

  tags = {
    Name = "Appwrite MySQL"
  }
}
