# modules/iam/outputs.tf
output "ec2_instance_role_name" {
  value = aws_iam_role.ec2_instance_role.name
}

output "asg_codedeploy_role_arn" {
  value = aws_iam_role.asg_codedeploy_role.arn
}
