# Route 53 Hosted Zone 생성
resource "aws_route53_zone" "this" {
  name = "wellness31.click"
}

# Route53 A record create(link load balancer)
resource "aws_route53_record" "this" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "wellness31.click"
  type    = "A"

  alias {
    name                   = aws_elb.app_lb.dns_name
    zone_id                = aws_elb.app_lb.zone_id
    evaluate_target_health = true
  }
}