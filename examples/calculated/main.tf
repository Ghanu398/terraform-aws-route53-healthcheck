provider "aws" {
  region = "ap-south-1"
}

resource "random_id" "suffix" {
  byte_length = 4
}



# # --- Child Health Check 1 ---
# resource "aws_route53_health_check" "child_1" {
#   fqdn              = "example.com"
#   port              = 443
#   type              = "HTTPS"
#   resource_path     = "/"
#   failure_threshold = 3
#   request_interval  = 30
# }

# # --- Child Health Check 2 ---
# resource "aws_route53_health_check" "child_2" {
#   fqdn              = "example.org"
#   port              = 443
#   type              = "HTTPS"
#   resource_path     = "/"
#   failure_threshold = 3
#   request_interval  = 30
# }


resource "aws_cloudwatch_metric_alarm" "alarm1" {
  alarm_name          = "cpu-alarm-1"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
}

resource "aws_cloudwatch_metric_alarm" "alarm2" {
  alarm_name          = "cpu-alarm-2"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
}

module "cw1" {
  source = "../../"

  name = "cw1"
  type = "CLOUDWATCH_METRIC"

  cloudwatch_alarm_name   = aws_cloudwatch_metric_alarm.alarm1.alarm_name
  cloudwatch_alarm_region = "ap-south-1"
}

module "cw2" {
  source = "../../"

  name = "cw2"
  type = "CLOUDWATCH_METRIC"

  cloudwatch_alarm_name   = aws_cloudwatch_metric_alarm.alarm2.alarm_name
  cloudwatch_alarm_region = "ap-south-1"
}


module "calculated_valid" {
  source = "../../"

  name = "calculated-valid"
  type = "CALCULATED"

  child_healthchecks = [
    {
      id   = module.cw1.health_check_id
      type = "endpoint"
    },
    {
      id   = module.cw2.health_check_id
      type = "CLOUDWATCH_METRIC"
    }
  ]

  child_health_threshold = 1
}

output "health_check_id" {
  value = module.calculated_valid.health_check_id
}
