variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "partner-devops-table"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}   