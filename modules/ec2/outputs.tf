output "ec2_sg_id" {
  description = "EC2  ID"
  value       = aws_security_group.ec2_sg.id
}

output "load_balancer_dns" {
  description = "Load balancer DNS"
  value       = aws_elb.app_lb.dns_name
}

output "load_balancer_zone_id" {
  description = "Load balancer zone ID"
  value       = aws_elb.app_lb.zone_id
}