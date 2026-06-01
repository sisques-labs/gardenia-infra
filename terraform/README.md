# Gardenia AWS (Terraform)

Provisions an **alpha** stack on AWS:

| Resource | Purpose |
| -------- | ------- |
| **VPC** | Public subnet (EC2) + private subnets (RDS) |
| **RDS** | PostgreSQL 16 for the API |
| **S3** | Asset storage (IAM access from EC2) |
| **EC2** | Runs `docker-compose.ec2.yml` (API + web) |

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.5
- AWS credentials (`aws configure` or env vars)
- Docker images published: `sisqueslabs/gardenia-api:alpha`, `sisqueslabs/gardenia-web:alpha`

## Deploy

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars (region, instance sizes, etc.)

terraform init
terraform plan
terraform apply
```

After apply:

```bash
terraform output web_url
terraform output api_url
```

Sensitive outputs:

```bash
terraform output -raw db_password
terraform output -raw jwt_secret
```

## EC2 bootstrap

On first boot the instance:

1. Installs Docker + Compose v2
2. Writes `/opt/gardenia/.env` (RDS endpoint, JWT, public URLs, S3 bucket)
3. Runs `docker compose` with `docker-compose.ec2.yml`

Connect via **SSM Session Manager** (no SSH key required):

```bash
aws ssm start-session --target "$(terraform output -raw ec2_instance_id)"
```

## State backend (optional)

See `backend.tf.example` for remote state in S3 + DynamoDB locking.

## Tear down

```bash
terraform destroy
```

RDS `skip_final_snapshot` is enabled for `environment = "alpha"`.
