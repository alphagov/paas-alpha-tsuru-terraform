variable "env" {
  description = "Environment name"
}

variable "office_cidrs" {
  description = "CSV of CIDR addresses for our office which will be trusted"
  default     = "80.194.77.90/32,80.194.77.100/32"
}

variable "jenkins_elastic" {
  description = "Elastic IP for Jenkins server which will be trusted"
  default     = "52.17.162.85/32"
}

variable "health_check_interval" {
  description = "Interval between requests for load balancer health checks"
  default     = 5
}

variable "health_check_timeout" {
  description = "Timeout of requests for load balancer health checks"
  default     = 2
}

variable "health_check_healthy" {
  description = "Threshold to consider load balancer healthy"
  default     = 2
}

variable "health_check_unhealthy" {
  description = "Threshold to consider load balancer unhealthy"
  default     = 2
}

variable "force_destroy" {
  description = "Delete GCS and S3 buckets content"
  default     = false
}

variable "postgres_bucketname" {
  description = "Bucket name for postgres WAL backups"
  default = "mcp-postgres-backup"
}
