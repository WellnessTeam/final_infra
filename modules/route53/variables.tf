variable "environment" {
  description = "environment name (예: dev, prod)"
  type        = string
}

variable "load_balancer_dns" {
  description = "Load balancer's DNS name"
  type        = string
}

variable "load_balancer_zone_id" {
  description = "Load balancer's Zone ID"
  type        = string
}
