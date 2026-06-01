data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_eip" "app" {
  domain = "vpc"

  tags = {
    Name = "${local.name_prefix}-eip"
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2.name

  root_block_device {
    volume_size = var.ec2_volume_size_gb
    volume_type = "gp3"
    encrypted   = true
  }

  user_data = base64encode(templatefile("${path.module}/templates/user_data.sh.tpl", {
    env_file_b64 = base64encode(templatefile("${path.module}/templates/stack.env.tpl", {
      api_image               = var.api_image
      web_image               = var.web_image
      api_port                = var.api_port
      web_port                = var.web_port
      database_host           = aws_db_instance.main.address
      database_username       = var.db_username
      database_password       = random_password.db_password.result
      database_name           = var.db_name
      database_synchronize    = var.database_synchronize ? "true" : "false"
      jwt_secret              = local.jwt_secret
      qr_base_url             = local.public_web_base
      next_public_api_url     = local.next_public_api
      next_public_graphql_url = local.next_public_graphql
      aws_region              = var.aws_region
      s3_bucket_name          = aws_s3_bucket.assets.id
    }))
    docker_compose_b64 = base64encode(file("${path.module}/../docker-compose.ec2.yml"))
  }))

  user_data_replace_on_change = true

  tags = {
    Name = "${local.name_prefix}-app"
  }

  depends_on = [
    aws_db_instance.main,
    aws_s3_bucket.assets,
  ]
}

resource "aws_eip_association" "app" {
  instance_id   = aws_instance.app.id
  allocation_id = aws_eip.app.id
}
