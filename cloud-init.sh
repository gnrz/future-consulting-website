#!/bin/bash
# Paste this whole file into DigitalOcean when creating the Droplet:
#   Create Droplet -> Advanced options -> "Add initialization scripts (free)"
# It does SETUP.md steps 3a-3d by itself on first boot (about 3-5 minutes).
# Progress log on the Droplet: /var/log/cloud-init-output.log
set -euxo pipefail

# 3a. Swap, so a 1 GB Droplet doesn't run out of memory
if [ ! -f /swapfile ]; then
  fallocate -l 1G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

# Docker (skipped if the image already has it)
command -v docker >/dev/null || curl -fsSL https://get.docker.com | sh

# 3b. Firewall: SSH and web only
ufw allow OpenSSH && ufw allow 80 && ufw allow 443 && ufw --force enable

# 3c. Code and generated passwords
if [ ! -d /opt/jackgannaway ]; then
  git clone https://github.com/gnrz/future-consulting-website.git /opt/jackgannaway
fi
cd /opt/jackgannaway
if [ ! -f .env ]; then
  cp .env.example .env
  sed -i "s|^DB_PASSWORD=.*|DB_PASSWORD=$(openssl rand -hex 24)|" .env
  sed -i "s|^DB_ROOT_PASSWORD=.*|DB_ROOT_PASSWORD=$(openssl rand -hex 24)|" .env
  chmod 600 .env
fi

# 3d. Start
docker compose up -d
chmod +x backup.sh
( crontab -l 2>/dev/null; echo "15 3 * * * /opt/jackgannaway/backup.sh >> /var/log/site-backup.log 2>&1" ) | sort -u | crontab -

echo "jackgannaway setup finished"
