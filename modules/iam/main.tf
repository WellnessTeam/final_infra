# modules/iam/main.tf

# EC2 인스턴스에 사용할 IAM 역할 생성
resource "aws_iam_role" "ec2_instance_role" {
  name = "ec2-instance-role-${var.environment}"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }]
  })
}

# S3 접근 권한 정책

# ECR 접근 권한 정책
resource "aws_iam_policy" "ecr_access_policy" {
  name = "ecr-access-policy-${var.environment}"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:GetAuthorizationToken"
      ],
      "Resource": "*"
    }]
  })
}

# Auto Scaling Group에 사용할 CodeDeploy 역할
resource "aws_iam_role" "asg_codedeploy_role" {
  name = "asg-codedeploy-role-${var.environment}"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "autoscaling.amazonaws.com"
                ]
            }
        }
    ]
  })
}

# CodeDeploy 권한 정책
resource "aws_iam_policy" "codedeploy_policy" {
  name = "codedeploy-policy-${var.environment}"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Action": [
        "codedeploy:*",
        "autoscaling:CompleteLifecycleAction",
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:UpdateAutoScalingGroup",
        "autoscaling:PutLifecycleHook",
        "autoscaling:DescribeLifecycleHooks"
      ],
      "Resource": "*"
    }]
  })
}

