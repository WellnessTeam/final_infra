output "db_endpoint" {
  description = "RDS instance's endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_id" {
  description = "RDS instace ID"
  value       = aws_db_instance.this.id
}

output "rds_sg_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds_sg.id
}
