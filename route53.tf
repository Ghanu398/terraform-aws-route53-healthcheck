resource "aws_route53_health_check" "this" {

  type = var.type

  # ---------------------------
  # Endpoint Health Check Args
  # ---------------------------
  fqdn          = var.fqdn
  port          = var.port
  resource_path = var.resource_path
  search_string = var.search_string

  # ---------------------------
  # CloudWatch Alarm Check Args
  # ---------------------------
  cloudwatch_alarm_name           = var.cloudwatch_alarm_name
  cloudwatch_alarm_region         = var.cloudwatch_alarm_region
  insufficient_data_health_status = var.insufficient_data_health_status

  # ---------------------------
  # Calculated Health Check Args
  # ---------------------------
  child_healthchecks     = length(var.child_healthchecks) > 0 ? var.child_healthchecks : null
  child_health_threshold = var.child_health_threshold

  # ---------------------------
  # Common Settings
  # ---------------------------
  failure_threshold = var.failure_threshold
  request_interval  = var.request_interval

  tags = {
    Name = var.name
  }
}