# modules/iam/outputs.tf

output "ec2_instance_role_name" {
  description = "EC2 Instance Role Name"
  value       = aws_iam_role.ec2_instance_role.name
}

output "asg_codedeploy_role_name" {
  description = "Auto Scaling CodeDeploy Role Name"
  value       = aws_iam_role.asg_codedeploy_role.name
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
