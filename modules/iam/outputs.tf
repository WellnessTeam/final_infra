# modules/iam/outputs.tf
output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_instance_profile.name  # 인스턴스 프로파일 이름을 출력
}

output "ec2_instance_role_name" {
  value = aws_iam_role.ec2_instance_role.name
}

output "asg_codedeploy_role_arn" {
  value = aws_iam_role.asg_codedeploy_role.arn
}
