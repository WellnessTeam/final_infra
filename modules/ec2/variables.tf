variable "environment" {
  description = "환경 이름 (예: dev, prod)"
  type        = string
}

variable "instance_type" {
  description = "EC2 인스턴스 유형"
  type        = string
}

variable "subnet_ids" {
  description = "EC2 인스턴스를 생성할 서브넷 ID"
  type        = list(any)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "key_name" {
  description = "EC2 인스턴스에 사용할 SSH 키 페어 이름"
  type        = string
}

# modules/ec2/variables.tf

# IAM 인스턴스 프로파일 (EC2에 할당할 IAM 역할)
variable "iam_instance_profile" {
  description = "IAM Instance profile for EC2"
  type        = string
}

# CodeDeploy 역할 ARN (Auto Scaling에 사용)
variable "service_linked_role_arn" {
  description = "CodeDeploy Role ARN for Auto Scaling"
  type        = string
}

