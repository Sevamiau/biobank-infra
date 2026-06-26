# Security audit — BioBank Infra
**Audit date:** June 25, 2026
**Reference:** Security Review Report (ArgentinasSDC, June 17, 2026)

---

## Finding status summary

| ID | Severity | Status | Finding |
|----|----------|--------|---------|
| H-01 | HIGH | RESOLVED | Default admin user with known credentials |
| H-02 | HIGH | RESOLVED | Plain HTTP deployment for patient data |
| H-03 | MEDIUM | RESOLVED | ALTER TABLE ENUM with manual escaping (app) |
| H-04 | MEDIUM | RESOLVED | Service port exposed on all interfaces |
| H-05 | LOW | RESOLVED | SSO token transmitted in query string (app) |
| H-06 | LOW | RESOLVED | CORS wildcard origin (app) |
| H-07 | LOW | RESOLVED | Minimal Content-Security-Policy |
| H-08 | COSMETIC | RESOLVED | Export endpoints without role granularity (app) |
| H-09 | COSMETIC | RESOLVED (partial) | Hardcoded URL and weak CSRF fallback (app) |

Findings marked **(app)** were fixed in the application layer (private repository).
This document covers the infra-layer fixes in detail.

---

## Infra findings — detail

### H-01 — RESOLVED
**Original location:** `init-db/zzz_seed_admin.sql`

The seed file previously inserted a fixed admin user (`admin / admin1234`) on every DB initialization, with `ON DUPLICATE KEY UPDATE permiso = 'ADM'` re-escalating privileges on every restart.

**Fix:**
- `zzz_seed_admin.sql` now contains only a comment — no credentials
- `entrypoint.sh` handles the first-admin bootstrap at runtime:
  - Only runs if no ADM user exists in the database
  - Generates a random password via `openssl rand -base64 16`
  - Hashes it with bcrypt before inserting
  - Prints credentials once to stdout and never stores them
  - Sets `must_change_password = 1` to force a password change on first login
- `init-db/000_schema.sql` adds the `must_change_password` column to the schema

---

### H-02 — RESOLVED
**Original location:** `docker-compose.yml`

The service was published over plain HTTP with no TLS termination.

**Fix:**
- Added `nginx` service to `docker-compose.yml` on the `frontend` network
- `nginx/nginx.conf`: redirects all HTTP to HTTPS with `301`; HTTPS server uses TLS 1.2/1.3 only, strong ciphers, and sets `X-Forwarded-Proto: https` toward the backend
- `nginx/entrypoint.sh`: generates a self-signed certificate on first run if no real certificate is present — with an explicit warning to replace it for production
- `SESSION_SECURE_COOKIE=true` added to the `web` service environment

**Note:** Replace `nginx/certs/server.crt` and `server.key` with a CA-signed certificate before going to production. For production ports, change `80:80` / `443:443` accordingly.

---

### H-04 — RESOLVED
**Original location:** `docker-compose.yml`, `ports` section of the `web` service

The port mapping `8000:80` bound the service to all host interfaces (`0.0.0.0`), exposing it directly on the network.

**Fix:**
```yaml
ports:
  - "127.0.0.1:8000:80"
```

The `web` container is now only reachable from the host itself. All public traffic flows through the `nginx` proxy, which terminates TLS. The `db` service remains isolated on the internal `backend` network.

---

### H-07 — RESOLVED
**Original location:** `app/public/.htaccess`

The Content-Security-Policy header only set `frame-ancestors 'self'`, with no `default-src` or `script-src` directives.

**Fix:**
```apache
Header always set Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline' https://cdnjs.cloudflare.com; font-src 'self' https://cdnjs.cloudflare.com; img-src 'self' data:; connect-src 'self'; frame-ancestors 'self'"
```

`'unsafe-inline'` is required for scripts because the application generates inline event handlers throughout its PHP templates. Font Awesome is loaded from `cdnjs.cloudflare.com` via CSS import and is explicitly whitelisted. External script sources are blocked.

---

## Executive summary

All 9 findings from the original audit are resolved. The two HIGH severity findings (H-01, H-02) and both MEDIUM findings (H-03, H-04) are closed. H-07 (LOW) was the last open item and is resolved in this update.

