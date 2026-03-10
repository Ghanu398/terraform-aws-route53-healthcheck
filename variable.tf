variable "aws_region" {
  type = string
}


# ---------------------------
# Common
# ---------------------------
variable "name" {
  description = "Name tag for the health check"
  type        = string
}

variable "type" {
  description = "Health check type: HTTP | HTTPS | TCP | CLOUDWATCH_METRIC | CALCULATED"
  type        = string
}

variable "failure_threshold" {
  description = "Number of consecutive failures before marking unhealthy"
  type        = number
  default     = 3
}

variable "request_interval" {
  description = "Health check interval in seconds (10 or 30)"
  type        = number
  default     = 30
}

# ---------------------------
# Endpoint Health Check Inputs
# ---------------------------
variable "fqdn" {
  description = "Domain name to monitor"
  type        = string
  default     = null
}

variable "port" {
  description = "Port to monitor"
  type        = number
  default     = null
}

variable "resource_path" {
  description = "URL path for HTTP/HTTPS checks"
  type        = string
  default     = null
}

variable "search_string" {
  description = "String to search in response body"
  type        = string
  default     = null
}

# ---------------------------
# CloudWatch Alarm Health Check Inputs
# ---------------------------
variable "cloudwatch_alarm_name" {
  description = "CloudWatch alarm name to monitor"
  type        = string
  default     = null
}

variable "cloudwatch_alarm_region" {
  description = "Region where CloudWatch alarm exists"
  type        = string
  default     = null
}

variable "insufficient_data_health_status" {
  description = "Health status when alarm has insufficient data"
  type        = string
  default     = "LastKnownStatus"
}

# ---------------------------
# Calculated Health Check Inputs
# ---------------------------
variable "child_healthchecks" {
  description = "List of child health check IDs"
  type        = list(string)
  default     = []
}

variable "child_health_threshold" {
  description = "Minimum number of healthy child checks required"
  type        = number
  default     = null
}