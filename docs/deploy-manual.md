# Manual Deployment Guide — AWS EC2

This guide covers deploying the app by hand on a fresh Ubuntu EC2 instance. It's the foundation for understanding what the Terraform automation does automatically.

For automated provisioning, see [`terraform/README.md`](../terraform/README.md).

---

## Prerequisites

- An EC2 instance running Ubuntu 22.04 or 24.04
- Security group with inbound rules: SSH (22), HTTP (80), HTTPS (443)
- Your SSH key pair to connect
- The app source code available locally

---

## 1. Connect to the instance

```bash
ssh -i /path/to/your-key.pem ubuntu@<public-ip>
```

Use the **public IP**, not the private one (172.x.x.x range is internal to AWS).

---

## 2. Install Docker

```bash
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER
newgrp docker
```

---

## 3. Copy the project to the server

From your **local machine**:

```bash
rsync -avz --exclude='backups/*.sql.gz' \
  -e "ssh -i /path/to/your-key.pem" \
  /path/to/repositorio-muestras/ \
  ubuntu@<public-ip>:~/repositorio-muestras/
```

---

## 4. Configure environment variables

On the EC2:

```bash
cd ~/repositorio-muestras
cp .env.example .env
nano .env
```

Set these values:

```env
DB_USERNAME=repo_app
DB_PASSWORD=<strong-password>
DB_ROOT_PASSWORD=<strong-password>
APP_URL=http://<public-ip>        # use https://your-domain.com if you have one
```

---

## 5. Start the Docker stack

```bash
docker compose up --build -d
```

Watch the database initialize:

```bash
docker compose logs -f db
# Wait for: "ready for connections"
# Then Ctrl+C
```

Verify all containers are healthy:

```bash
docker compose ps
```

The app is now accessible at `http://<public-ip>:8000`.

---

## 6. Install and configure Nginx

Nginx acts as a reverse proxy on port 80, forwarding traffic to the Docker container on port 8000.

```bash
sudo apt install nginx -y
```

Create the site config:

```bash
sudo nano /etc/nginx/sites-available/repositorio-muestras
```

Paste:

```nginx
server {
    listen 80;
    server_name <public-ip-or-domain>;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}
```

Enable it:

```bash
sudo ln -s /etc/nginx/sites-available/repositorio-muestras /etc/nginx/sites-enabled/repositorio-muestras
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
```

The app is now accessible at `http://<public-ip>` (no port needed).

---

## 7. Enable services on reboot

Docker containers restart automatically (`restart: always` in docker-compose.yml). Make sure Docker and Nginx start on boot:

```bash
sudo systemctl enable docker nginx
```

---

## 8. Add a swap file (recommended for t2/t3.micro)

Free tier instances have 1 GB RAM. A swap file prevents out-of-memory crashes:

```bash
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

---

## 9. Lock down the security group

Remove any custom port rules (e.g. 8000) added during testing. In production, only ports 22, 80, and 443 should be open.

---

## 10. (Optional) HTTPS with Let's Encrypt

Requires a domain name with an A record pointing to the server's Elastic IP.

```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d your-domain.com
```

Certbot edits the Nginx config automatically and sets up auto-renewal.

---

## Verifying the deployment

```bash
# All containers running?
docker compose ps

# App reachable from Nginx?
curl -I http://localhost

# Nginx logs
sudo tail -f /var/log/nginx/access.log

# App logs
docker compose logs -f web
```
