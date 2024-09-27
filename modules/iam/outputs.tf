# modules/iam/outputs.tf

output "ec2_instance_role_name" {
  description = "EC2 Instance Role Name"
  value       = aws_iam_role.ec2_instance_role.name
}

output "asg_role_name" {
  description = "Auto Scaling Role Name"
  value       = aws_iam_role.asg_role.name  # 변경된 부분
}

output "codedeploy_role_name" {
  description = "CodeDeploy Role Name"
  value       = aws_iam_role.codedeploy_role.name
}

output "s3_access_policy_arn" {
  description = "S3 Access Policy ARN"
  value       = aws_iam_policy.s3_access_policy.arn
}

output "ecr_access_policy_arn" {
  description = "ECR Access Policy ARN"
  value       = aws_iam_policy.ecr_access_policy.arn
}
