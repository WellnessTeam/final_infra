# EC2 인스턴스를 위한 보안 그룹 설정
resource "aws_security_group" "ec2_sg" {
  name        = "${var.environment}-ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id

  # SSH 접근 (보안을 위해 IP 제한 필요)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # HTTP 접근
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 포트 9000에 대한 접근 허용
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 포트 8001에 대한 접근 허용
  ingress {
    from_port   = 8001
    to_port     = 8001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-ec2-sg"
    Environment = var.environment
  }
}

# Amazon Linux 2 AMI를 SSM Parameter Store에서 가져오기
data "aws_ssm_parameter" "amazon_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_launch_configuration" "app" {
  name            = "${var.environment}-launch-config"
  image_id        = data.aws_ssm_parameter.amazon_linux.value
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              sudo chkconfig docker on
              EOF
}

# Auto Scaling Group 설정
resource "aws_autoscaling_group" "app_asg" {
  launch_configuration = aws_launch_configuration.app.id
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2
  vpc_zone_identifier  = var.subnet_ids

  tag {
    key                 = "Name"
    value               = "{var.environment}-autoscaling"
    propagate_at_launch = true
  }
}

#Load Balancer 설정
resource "aws_elb" "app_lb" {
  name    = "${var.environment}-elb"
  subnets = var.subnet_ids

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

}

# Auto Scaling Group을 ELB와 연결
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  elb                    = aws_elb.app_lb.id
}