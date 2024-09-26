# VPC 관련 출력
output "vpc_id" {
  description = "create VPC ID"
  value       = module.vpc.vpc_id
}
