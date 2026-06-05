#!/bin/bash

set -euo pipefail

log() { echo "[user_data] $*" | tee -a /var/log/user_data.log; }

log "Starting bootstrap — $(date)"

apt-get update -y
apt-get upgrade -y

log "Installing Docker..."
curl -fsSL https://get.docker.com | sh
usermod -aG docker ubuntu

log "Installing Nginx..."
apt-get install -y nginx

log "Installing Certbot..."
apt-get install -y certbot python3-certbot-nginx

log "Writing Nginx config..."
cat >/etc/nginx/sites-available/repo-mds <<'NGINX'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass         http://localhost:8000;
        proxy_http_version 1.1;

        # Forward the real client IP and protocol to the app.
        # The app uses X-Forwarded-Proto to decide whether to enforce HTTPS.
        proxy_set_header   Host              $host;
        proxy_set_header   X-Real-IP         $remote_addr;
        proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto https;
    }
}
NGINX

ln -sf /etc/nginx/sites-available/repo-mds /etc/nginx/sites-enabled/repo-mds
rm -f /etc/nginx/sites-enabled/default

nginx -t && systemctl reload nginx

log "Bootstrap complete — $(date)"
log "Next steps (run manually after SSH-ing in):"
log "  1. Copy your app source to /home/ubuntu/repositorio-muestras/app/"
log "  2. Edit /home/ubuntu/repositorio-muestras/.env with real credentials"
log "  3. docker compose up --build -d"
log "  4. Point your domain A record to this server's Elastic IP"
log "  5. sudo certbot --nginx -d your-domain.com"
