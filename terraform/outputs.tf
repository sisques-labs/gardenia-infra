output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.main.id
}

output "ec2_instance_id" {
  description = "EC2 instance ID running API and web."
  value       = aws_instance.app.id
}

output "elastic_ip" {
  description = "Public Elastic IP of the application host."
  value       = aws_eip.app.public_ip
}

output "web_url" {
  description = "Web application URL."
  value       = local.public_web_base
}

output "api_url" {
  description = "REST API base URL."
  value       = local.next_public_api
}

output "graphql_url" {
  description = "GraphQL endpoint URL."
  value       = local.next_public_graphql
}

output "rds_endpoint" {
  description = "RDS hostname (private)."
  value       = aws_db_instance.main.endpoint
}

output "s3_bucket_name" {
  description = "S3 bucket for Gardenia assets."
  value       = aws_s3_bucket.assets.id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN."
  value       = aws_s3_bucket.assets.arn
}

output "db_username" {
  description = "RDS master username."
  value       = var.db_username
}

output "db_password" {
  description = "RDS master password (sensitive)."
  value       = random_password.db_password.result
  sensitive   = true
}

output "jwt_secret" {
  description = "JWT secret used by the API (sensitive)."
  value       = local.jwt_secret
  sensitive   = true
}
