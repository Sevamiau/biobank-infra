#!/bin/sh
set -e

CERT_DIR=/etc/nginx/certs

# Generate a self-signed certificate on first run if none is present.
# Replace server.crt / server.key with a real certificate for production.
if [ ! -f "$CERT_DIR/server.crt" ] || [ ! -f "$CERT_DIR/server.key" ]; then
    echo "[nginx] No TLS certificate found — generating self-signed certificate."
    echo "[nginx] Replace /etc/nginx/certs/server.crt and server.key with a real cert for production."
    apk add --no-cache openssl 2>/dev/null
    mkdir -p "$CERT_DIR"
    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
        -keyout "$CERT_DIR/server.key" \
        -out   "$CERT_DIR/server.crt" \
        -subj  "/CN=localhost/O=BioBank/C=AR"
    echo "[nginx] Self-signed certificate generated."
fi

exec nginx -g 'daemon off;'
