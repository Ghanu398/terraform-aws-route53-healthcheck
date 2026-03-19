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


module "duplicate_child_test" {
  source = "../../"

  name = "duplicate-child"

  type = "CALCULATED"

  child_healthchecks = [
    aws_route53_health_check.child_1.id,
    aws_route53_health_check.child_1.id
  ]

  child_health_threshold = 1

  tags = {
    Scenario = "duplicate-child"
  }
}

output "health_check_id" {
  value = module.duplicate_child_test.health_check_id
}
