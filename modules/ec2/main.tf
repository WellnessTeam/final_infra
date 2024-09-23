# EC2 인스턴스를 위한 보안 그룹 설정
resource "aws_security_group" "ec2_sg" {
  name        = "${var.environment}-ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH 접근 (보안을 위해 IP 제한 필요)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTP 접근
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

# EC2 인스턴스 생성
resource "aws_instance" "this" {
  ami                    = data.aws_ssm_parameter.amazon_linux.value # SSM Parameter에서 가져온 AMI ID 사용
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_name # SSH 접근을 위한 키

  tags = {
    Name        = "${var.environment}-ec2"
    Environment = var.environment
  }
}

# Elastic IP allocation
resource "aws_eip" "this" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-eip"
  }
}

# Associage Elastic IP with EC2 instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.this.id
  allocation_id = aws_eip.this.id
}
