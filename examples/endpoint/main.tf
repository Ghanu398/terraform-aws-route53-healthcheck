provider "aws" {
  region = "ap-south-1"
}

module "test_endpoint" {
  source = "../../"   # go up to module root

  name = "test-endpoint"
  type = "HTTPS"

  fqdn          = "example.com"
  port          = 443
  resource_path = "/"
}

output "health_check_id" {
  value = module.test_endpoint.health_check_id
}