provider "aws" {
  region  = "ap-south-1"
  profile = "terraform"
}

module "endpoint_ip_healthcheck" {
  source = "../../"

  name = "ip-based-healthcheck"

  type = "HTTP"

  ip_address =    "3.110.25.10" 
  port       = 80

  resource_path = "/health"

  request_interval  = 30
  failure_threshold = 3

  tags = {
    Environment = "prod"
    Mode        = "direct-ip-check"
  }
}

output "health_check_id" {
  value = module.endpoint_ip_healthcheck.health_check_id
}