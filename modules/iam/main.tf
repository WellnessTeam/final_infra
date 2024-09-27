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
resource "aws_iam_policy" "s3_access_policy" {
  name = "s3-access-policy-${var.environment}"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::dev-wellness-codedeploy-script/*"
    }]
  })
}

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

# Auto Scaling Group에 사용할 IAM 역할 생성
resource "aws_iam_role" "asg_role" {
  name = "asg-role-${var.environment}"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Service": "autoscaling.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }]
  })
}

# Auto Scaling 정책을 EC2 역할에 부착
resource "aws_iam_role_policy_attachment" "attach_s3_policy_to_asg" {
  policy_arn = aws_iam_policy.s3_access_policy.arn
  role       = aws_iam_role.asg_role.name
}

resource "aws_iam_role_policy_attachment" "attach_ecr_policy_to_asg" {
  policy_arn = aws_iam_policy.ecr_access_policy.arn
  role       = aws_iam_role.asg_role.name
}

# CodeDeploy 역할 생성
resource "aws_iam_role" "codedeploy_role" {
  name = "codedeploy-role-${var.environment}"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }]
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

# CodeDeploy 정책을 CodeDeploy 역할에 부착
resource "aws_iam_role_policy_attachment" "attach_codedeploy_policy" {
  policy_arn = aws_iam_policy.codedeploy_policy.arn
  role       = aws_iam_role.codedeploy_role.name
}

# CodeDeploy Auto Scaling 정책을 CodeDeploy 역할에 부착
resource "aws_iam_role_policy_attachment" "attach_asg_policy_to_codedeploy" {
  policy_arn = aws_iam_policy.codedeploy_policy.arn  # 이 부분을 변경하여 Auto Scaling 정책을 사용할 수 있습니다
  role       = aws_iam_role.codedeploy_role.name
}

#EC2 인스턴스 IAM 역할: EC2 인스턴스가 필요한 권한을 가질 수 있도록 역할을 생성합니다.

#3 및 ECR 접근 정책: 각각의 서비스에 대한 접근 권한을 설정합니다.

#Auto Scaling 역할: Auto Scaling 그룹에서 사용할 역할을 생성하고, S3와 ECR 정책을 이 역할에 부착합니다.

#CodeDeploy 역할: CodeDeploy가 EC2 인스턴스에 배포할 수 있도록 설정된 역할을 생성합니다.

#정책 부착:

#S3 및 ECR 접근 정책을 Auto Scaling 역할에 부착합니다.
#CodeDeploy 역할에는 CodeDeploy 관련 정책을 부착합니다.