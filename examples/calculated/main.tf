provider "aws" {
  region = "ap-south-1"
}

resource "random_id" "suffix" {
  byte_length = 4
}



# --- Child Health Check 1 ---
resource "aws_route53_health_check" "child_1" {
  fqdn              = "example.com"
  port              = 443
  type              = "HTTPS"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
}

# --- Child Health Check 2 ---
resource "aws_route53_health_check" "child_2" {
  fqdn              = "example.org"
  port              = 443
  type              = "HTTPS"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
}


# --- Child Health Check 1 ---
resource "aws_route53_health_check" "child_3" {
  fqdn              = "example.com1"
  port              = 443
  type              = "HTTPS"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
}

# --- Child Health Check 2 ---
resource "aws_route53_health_check" "child_4" {
  fqdn              = "example.org1"
  port              = 443
  type              = "HTTPS"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
}

# --- Your Module (Calculated Parent) ---
module "region1_health" {
  source = "../../"

  name = "region1-health-${random_id.suffix.hex}"

  type = "CALCULATED"

  child_healthchecks = [
    aws_route53_health_check.child_1.id,
    aws_route53_health_check.child_2.id
  ]

  child_health_threshold = 1

  tags = {
    Region = "ap-south-1"
  }
}

module "region2_health" {
  source = "../../"

  name = "region2-health-${random_id.suffix.hex}"

  type = "CALCULATED"

  child_healthchecks = [
    aws_route53_health_check.child_3.id,
    aws_route53_health_check.child_4.id
  ]

  child_health_threshold = 1

  tags = {
    Region = "us-east-1"
  }
}

# data "aws_route53_health_check" "region-2" {
#   health_check_id = module.region2_health.health_check_id
#   provider = aws.region-2
  
# }

resource "time_sleep" "wait_for_healthchecks" {
  depends_on = [
    module.region1_health,
    module.region2_health
  ]

  create_duration = "30s"
}

module "global_health" {
  source = "../../"

  name = "global-health-${random_id.suffix.hex}"

  type = "CALCULATED"

  child_healthchecks = [
    module.region1_health.health_check_id,
    module.region2_health.health_check_id
  ]

  child_health_threshold = 1

  depends_on = [time_sleep.wait_for_healthchecks]

  tags = {
    Scenario = "multi-region-nested"
  }
}

output "health_check_id" {
  value = module.global_health.health_check_id
}
