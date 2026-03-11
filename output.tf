output "health_check_id" {
  description = "Route53 health check ID"
  value       = aws_route53_health_check.this.id
}

output "health_check_arn" {
  description = "Route53 health check ARN"
  value       = aws_route53_health_check.this.arn
}