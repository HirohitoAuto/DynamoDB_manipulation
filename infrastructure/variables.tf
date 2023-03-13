# ---------------------------------
# --- Lambda
# ---------------------------------

variable "function_name" {
  description = "Function名"
  type        = string
  default     = "lambda_manipulate_dynamodb"
}

variable "size" {
  description = "strage size"
  type        = string
  default     = "512"
}


variable "memory_size" {
  description = "memory size"
  type        = string
  default     = "128"
}

variable "package_type" {
  description = "package type"
  type        = string
  default     = "Image"
}


variable "timeout" {
  description = "timeout in seconds"
  type        = string
  default     = "300"
}

# ---------------------------------
# --- ECR
# ---------------------------------

variable "ecr_repository_name" {
  description = "repository_name"
  type        = string
  default     = "ecr_manupulate_dynamodb"
}

# ---------------------------------
# --- IAM Role
# ---------------------------------
variable "iam_role_name" {
  description = "Function名"
  type        = string
  default     = "aim_manupulate_dynamodb"
}