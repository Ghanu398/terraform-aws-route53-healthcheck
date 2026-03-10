output "health_check_id" {
  description = "ID of the Route53 health check"
  value       = aws_route53_health_check.this.id
}

output "health_check_arn" {
  description = "ARN of the Route53 health check"
  value       = aws_route53_health_check.this.arn
}