# App bucket
resource "aws_s3_bucket" "app_bucket" {
  bucket = "${var.environment}-wellnessapp-bucket"

  tags = {
    Name        = "${var.environment}-wellnessapp-bucket"
    Environment = var.environment
  }
}

# tfstate storage bucket
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "${var.environment}-wellness-terraform-state"

  tags = {
    Name        = "${var.environment}-terraform-wellness-state"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "${var.environment}-wellness-codedeploy_script"

  tags = {
    Name        = "${var.environment}-terraform-wellness-codedeploy"
    Environment = var.environment
  }
}
