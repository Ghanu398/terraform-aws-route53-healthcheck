provider "aws" {
  region = "ap-south-1"
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

# --- Your Module (Calculated Parent) ---
module "test_calculated" {
  source = "../../"   # points to your module

  name = "test-calculated-hc"
  type = "CALCULATED"

  child_healthchecks = [
    aws_route53_health_check.child_1.id,
    aws_route53_health_check.child_2.id
  ]

  child_health_threshold = 1
}

output "health_check_id" {
  value = module.test_calculated.health_check_id
}
