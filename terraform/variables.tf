variable "project_name" {
  type        = string
  description = "Project name used for resource naming."
  default     = "gardenia"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. alpha, staging)."
  default     = "alpha"
}

variable "aws_region" {
  type        = string
  description = "AWS region for all resources."
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block."
  default     = "10.0.0.0/16"
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type for the application host."
  default     = "t3.small"
}

variable "ec2_volume_size_gb" {
  type        = number
  description = "Root EBS volume size in GB."
  default     = 30
}

variable "rds_instance_class" {
  type        = string
  description = "RDS instance class."
  default     = "db.t4g.micro"
}

variable "rds_allocated_storage_gb" {
  type        = number
  description = "RDS allocated storage in GB."
  default     = 20
}

variable "db_name" {
  type        = string
  description = "PostgreSQL database name."
  default     = "gardenia_db"
}

variable "db_username" {
  type        = string
  description = "PostgreSQL master username."
  default     = "gardenia"
}

variable "api_image" {
  type        = string
  description = "Docker image for the API service."
  default     = "sisqueslabs/gardenia-api:alpha"
}

variable "web_image" {
  type        = string
  description = "Docker image for the web service."
  default     = "sisqueslabs/gardenia-web:alpha"
}

variable "api_port" {
  type        = number
  description = "Host port mapped to the API container."
  default     = 3000
}

variable "web_port" {
  type        = number
  description = "Host port mapped to the web container."
  default     = 80
}

variable "jwt_secret" {
  type        = string
  description = "JWT signing secret for the API. Leave empty to auto-generate."
  default     = ""
  sensitive   = true
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR allowed to SSH into EC2. Set to empty string to disable SSH."
  default     = ""
}

variable "database_synchronize" {
  type        = bool
  description = "Whether the API should auto-sync schema (alpha only; use false with migrations in production)."
  default     = false
}
