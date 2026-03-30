variable "name" {
  description = "Name tag for the health check"
  type        = string
}

variable "type" {
  description = "Health check type"
  type        = string

  validation {
    condition     = contains(["CLOUDWATCH_METRIC","CALCULATED"], var.type)
    error_message = "Only CLOUDWATCH_METRIC and CALCULATED are allowed."
  }
}

# -------------------------
# CloudWatch Inputs
# -------------------------
variable "cloudwatch_alarm_name" {
  type    = string
  default = null

  validation {
    condition     = var.type != "CLOUDWATCH_METRIC" || var.cloudwatch_alarm_name != null
    error_message = "cloudwatch_alarm_name must be provided when type is CLOUDWATCH_METRIC."
  }
}

variable "cloudwatch_alarm_region" {
  type    = string
  default = null

  validation {
    condition     = var.type != "CLOUDWATCH_METRIC" || var.cloudwatch_alarm_region != null
    error_message = "cloudwatch_alarm_region must be provided when type is CLOUDWATCH_METRIC."
  }
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
  type    = bool 
  default = false
}

# -------------------------
# Calculated Inputs
# -------------------------
variable "child_healthchecks" {
  type = list(object({
    id   = string
    type = string
  }))
  default = []

  #Length validation
  validation {
    condition = (
      var.type != "CALCULATED" ||
      (length(var.child_healthchecks) > 0 && length(var.child_healthchecks) <= 8)
    )
    error_message = "For CALCULATED type, child_healthchecks must be between 1 and 8."
  }

  #Only CLOUDWATCH_METRIC allowed
  validation {
    condition = (
      var.type != "CALCULATED" ||
      alltrue([
        for hc in var.child_healthchecks :
        hc.type == "CLOUDWATCH_METRIC"
      ])
    )
    error_message = "All child health checks must be of type CLOUDWATCH_METRIC."
  }

  #Prevent duplicate IDs
  validation {
    condition = (
      var.type != "CALCULATED" ||
      length([
        for hc in var.child_healthchecks : hc.id
      ]) == length(distinct([
        for hc in var.child_healthchecks : hc.id
      ]))
    )
    error_message = "Duplicate child health check IDs are not allowed."
  }
}

variable "child_health_threshold" {
  type    = number
  default = null

  validation {
    condition = (
      var.type != "CALCULATED" ||
      (
        var.child_health_threshold >= 1 &&
        var.child_health_threshold <= length(var.child_healthchecks)
      )
    )
    error_message = "child_health_threshold must be between 1 and number of child_healthchecks."
  }
}

variable "tags" {
  description = "Tags for health check"
  type        = map(string)
  default     = {}
}

variable "inverted_health_check" {
  type    = bool
  default = false
}