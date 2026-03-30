locals {
  is_cloudwatch = var.type == "CLOUDWATCH_METRIC"
  is_calculated = var.type == "CALCULATED"
}


resource "aws_route53_health_check" "this" {
  type = var.type

  # -------------------------
  # CloudWatch Alarm Check
  # -------------------------
  cloudwatch_alarm_name   = local.is_cloudwatch ? var.cloudwatch_alarm_name : null
  cloudwatch_alarm_region = local.is_cloudwatch ? var.cloudwatch_alarm_region : null
  insufficient_data_health_status = local.is_cloudwatch ? var.insufficient_data_health_status : null

  # -------------------------
  # Calculated Health Check (ONLY CloudWatch-based)
  # -------------------------
  child_healthchecks = local.is_calculated ? [
  for hc in var.child_healthchecks : hc.id
] : null
  child_health_threshold = local.is_calculated ? var.child_health_threshold : null

  # -------------------------
  # Common
  # -------------------------
  disabled              = var.disable
  measure_latency       = var.measure_latency
  invert_healthcheck    = var.inverted_health_check
  tags                  = var.tags

}