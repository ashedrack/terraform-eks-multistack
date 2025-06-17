resource "aws_db_instance" "postgres" {
  allocated_storage    = var.allocated_storage
  engine               = "postgres"
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  name                 = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
  skip_final_snapshot  = true
  tags = merge(var.tags, { Name = "${var.name}-rds" })
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}
