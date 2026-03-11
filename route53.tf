locals {
  is_endpoint   = contains(["HTTP", "HTTPS", "TCP"], var.type)
  is_cloudwatch = var.type == "CLOUDWATCH_METRIC"
  is_calculated = var.type == "CALCULATED"
}

resource "aws_route53_health_check" "this" {
  type = var.type

  # -------------------------
  # Endpoint Health Check
  # -------------------------
  fqdn          = local.is_endpoint ? var.fqdn : null
  port          = local.is_endpoint ? var.port : null
  resource_path = local.is_endpoint ? var.resource_path : null
  search_string = local.is_endpoint ? var.search_string : null

  # -------------------------
  # CloudWatch Alarm Check
  # -------------------------
  cloudwatch_alarm_name   = local.is_cloudwatch ? var.cloudwatch_alarm_name : null
  cloudwatch_alarm_region = local.is_cloudwatch ? var.cloudwatch_alarm_region : null
  insufficient_data_health_status = local.is_cloudwatch ? var.insufficient_data_health_status : null

  # -------------------------
  # Calculated Health Check
  # -------------------------
  child_healthchecks     = local.is_calculated ? var.child_healthchecks : null
  child_health_threshold = local.is_calculated ? var.child_health_threshold : null

  # -------------------------
  # Common Settings
  # -------------------------
  failure_threshold = local.is_endpoint ? var.failure_threshold : null
  request_interval  = local.is_endpoint ? var.request_interval : null

  tags = {
    Name = var.name
  }
}