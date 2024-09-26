output "dynamodb_table_name" {
  description = "The name of the DynamoDB table for terraform state locking"
  value       = aws_dynamodb_table.terraform_lock.name
}

output "rds_sg_id" {
  description = "RDS security_group ID"
  value       = aws_security_group.rds_sg.id
}
