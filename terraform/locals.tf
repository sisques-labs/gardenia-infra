locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
  }

  jwt_secret = var.jwt_secret != "" ? var.jwt_secret : random_password.jwt_secret[0].result

  # Browser-reachable URLs (Elastic IP on EC2)
  public_api_base    = "http://${aws_eip.app.public_ip}:${var.api_port}"
  public_web_base    = "http://${aws_eip.app.public_ip}:${var.web_port}"
  next_public_api    = "${local.public_api_base}/api"
  next_public_graphql = "http://${aws_eip.app.public_ip}:${var.api_port}/graphql"
}

resource "random_password" "jwt_secret" {
  count   = var.jwt_secret == "" ? 1 : 0
  length  = 48
  special = false
}

resource "random_password" "db_password" {
  length  = 32
  special = false
}
