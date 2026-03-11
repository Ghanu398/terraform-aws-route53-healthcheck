provider "aws" {
  region = "ap-south-1"
}

module "test_cloudwatch" {
  source = "../../"   # points to your module root

  name = "test-cloudwatch-hc"
  type = "CLOUDWATCH_METRIC"

  cloudwatch_alarm_name   = "HighCPU-Alarm"
  cloudwatch_alarm_region = "ap-south-1"
}