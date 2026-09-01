variable "table_name" {
  description = "The name of the Dynamodb-table"
  type        = string
}

variable "billing_mode" {
  description = "Billing mode for database"
  type        = string
  default     = "PAY_PER_REQUEST"
}
