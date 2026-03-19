variable "name" {
  description = "Name tag for the health check"
  type        = string
}

variable "type" {
  description = "Health check type"
  type        = string

  validation {
    condition     = contains(["HTTP","HTTPS","TCP","HTTP_STR_MATCH","CLOUDWATCH_METRIC","CALCULATED"], var.type)
    error_message = "type must be HTTP, HTTPS, TCP, HTTP_STR_MATCH, CLOUDWATCH_METRIC, or CALCULATED."
  }
}

# -------------------------
# Endpoint Inputs
# -------------------------
variable "fqdn" {
  type    = string
  default = null
}
variable "ip_address" {
  type    = string
  default = null
  
}
variable "port" {
  type    = number
  default = null
}

variable "resource_path" {
  type    = string
  default = null
}

variable "search_string" {
  type    = string
  default = null
}

variable "failure_threshold" {
  type    = number
  default = 3
}

variable "request_interval" {
  type    = number
  default = 30

  validation {
    condition     = contains([10,30], var.request_interval)
    error_message = "request_interval must be 10 or 30 seconds."
  }
}

# -------------------------
# CloudWatch Inputs
# -------------------------
variable "cloudwatch_alarm_name" {
  type    = string
  default = null
}

variable "cloudwatch_alarm_region" {
  type    = string
  default = null
}

variable "insufficient_data_health_status" {
  type    = string
  default = "LastKnownStatus"

  validation {
    condition     = contains(["Healthy","Unhealthy","LastKnownStatus"], var.insufficient_data_health_status)
    error_message = "insufficient_data_health_status must be Healthy, Unhealthy, or LastKnownStatus."
  }
}

variable "measure_latency" {
  type    = bool
  default = false
}

variable "disable" {
  type = bool 
  default = false
}

# -------------------------
# Calculated Inputs
# -------------------------
variable "child_healthchecks" {
  type    = list(string)
  default = []
}

variable "child_health_threshold" {
  type    = number
  default = null
}

variable "tags" {
  description = "Tags for health check"
  type        = map(string)
  default     = {}
}

variable "inverted_health_check" {
  type = bool
  default = false
}

variable "regions" {
  type = list(string)
  default = ["us-east-1", "us-west-1", "us-west-2", "eu-west-1", "ap-southeast-1", "ap-southeast-2", "ap-northeast-1", "sa-east-1"]
}