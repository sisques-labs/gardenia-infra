#!/bin/bash
set -euo pipefail

exec > >(tee /var/log/gardenia-user-data.log) 2>&1

echo "==> Installing Docker"
dnf update -y
dnf install -y docker wget
systemctl enable --now docker

mkdir -p /usr/local/lib/docker/cli-plugins
curl -fsSL "https://github.com/docker/compose/releases/download/v2.32.4/docker-compose-linux-$(uname -m)" \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
ln -sf /usr/local/lib/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose

echo "==> Writing Gardenia stack"
install -d -m 0600 /opt/gardenia
echo "${env_file_b64}" | base64 -d > /opt/gardenia/.env
chmod 0600 /opt/gardenia/.env
echo "${docker_compose_b64}" | base64 -d > /opt/gardenia/docker-compose.yml

echo "==> Starting services"
cd /opt/gardenia
docker compose --env-file .env pull
docker compose --env-file .env up -d

echo "==> Gardenia stack started"
