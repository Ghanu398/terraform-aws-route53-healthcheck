provider "aws" {
  region = "ap-south-1"
}

# Create SNS Topic (required for alarm)
resource "aws_sns_topic" "test" {
  name = "test-topic"
}

# Create CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "HighCPU-Alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80

  alarm_actions = [aws_sns_topic.test.arn]
}

# Route53 Health Check (your module)
module "test_cloudwatch" {
  source = "../../"

  name = "test-cloudwatch-hc"
  type = "CLOUDWATCH_METRIC"

  cloudwatch_alarm_name   = aws_cloudwatch_metric_alarm.high_cpu.alarm_name
  cloudwatch_alarm_region = "ap-south-1"
}

output "health_check_id" {
  value = module.test_cloudwatch.health_check_id
}