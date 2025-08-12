variable "tfc_organization" {
  description = "HCP Terraform organization name"
  type        = string
  default     = "ChuksTech"
}

variable "tfc_workspace" {
  description = "HCP Terraform workspace name"
  type        = string
  default     = "AWS-S3"
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket (must be globally unique)"
  type        = string
  default     = "Chuks-S3"
}

variable "environment" {
  description = "Environment tag for resources"
  type        = string
  default     = "dev"
  
  validation {
    condition = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "enable_website_hosting" {
  description = "Enable static website hosting for the S3 bucket"
  type        = bool
  default     = true
}

variable "enable_cors" {
  description = "Enable CORS configuration for the S3 bucket"
  type        = bool
  default     = false
}

variable "enable_lifecycle" {
  description = "Enable lifecycle configuration for the S3 bucket"
  type        = bool
  default     = true
}

variable "lifecycle_noncurrent_version_expiration_days" {
  description = "Number of days after which noncurrent versions will be deleted"
  type        = number
  default     = 90
  
  validation {
    condition = var.lifecycle_noncurrent_version_expiration_days > 0
    error_message = "Lifecycle expiration days must be greater than 0."
  }
}

variable "lifecycle_abort_incomplete_multipart_upload_days" {
  description = "Number of days after which incomplete multipart uploads will be aborted"
  type        = number
  default     = 7
  
  validation {
    condition = var.lifecycle_abort_incomplete_multipart_upload_days > 0
    error_message = "Abort incomplete multipart upload days must be greater than 0."
  }
}