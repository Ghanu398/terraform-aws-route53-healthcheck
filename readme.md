# Terraform AWS Route53 Health Check Module

## Features
- Endpoint health checks (HTTP/HTTPS/TCP)
- CloudWatch alarm health checks
- Calculated (composite) health checks

## Usage

```hcl
module "hc" {
  source  = "github.com/Ghanu398/terraform-aws-route53-healthcheck"
  version = "1.0.0"

  name = "app-health"
  type = "HTTPS"

  fqdn = "app.example.com"
  port = 443
}