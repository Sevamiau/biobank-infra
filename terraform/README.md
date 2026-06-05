# Proposed AWS Architecture

This directory contains a Terraform-based AWS deployment design for the biobank system. It is a **proposal** — the foundation currently runs the app on-premises and has not yet adopted this setup.

## Why this architecture

The requirements were a tight NGO budget and minimal operational complexity. The obvious managed-services path (Fargate + RDS + ALB) would cost roughly $60–80/month. A single EC2 t3.micro with Docker Compose running the same stack costs ~$10/month — the same workload for a sixth of the price, with no meaningful difference in reliability for a small internal tool.

Nginx runs on the bare instance rather than in a container so it can handle SSL termination via Let's Encrypt (Certbot needs direct access to port 80 for the HTTP-01 challenge). Everything else runs in Docker Compose, identical to the local deployment.

## What it provisions

| Resource | Detail |
|---|---|
| EC2 instance | Ubuntu 24.04 LTS, t3.micro |
| Security Group | Port 22 open to your IP only; 80 and 443 open to the world |
| Elastic IP | Static public IP |

`user_data.sh` runs automatically on first boot and installs Docker, Nginx, and Certbot. The app stack is then started manually after cloning the repo and setting credentials.

## Architecture

```
Internet
    │  443 / 80
    ▼
EC2 t3.micro (Ubuntu 24.04)
    └── Nginx  ← reverse proxy, SSL termination (Let's Encrypt, when domain is assigned)
         └── Docker Compose (port 8000, internal)
              ├── web     (PHP 8.2 + Apache)
              ├── db      (MariaDB — backend network only)
              └── backup  (mysqldump every 24h)
```

SSL is not yet active — the foundation does not have a domain assigned to this server. Certbot is pre-installed; enabling HTTPS is a single command once a domain is pointed at the Elastic IP.

## Deploying

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Set: aws_region, key_pair_name, my_ip

terraform init
terraform plan
terraform apply
# Outputs the Elastic IP and a ready-to-use SSH command
```

After `apply`, SSH in, clone the repo, copy `.env.example` to `.env`, add the app source to `app/`, and run `docker compose up --build -d`.

## Tearing it down

```bash
terraform destroy
```

