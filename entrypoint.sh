#!/bin/sh
set -e

mkdir -p \
    /var/www/html/frmwk/storage/framework/sessions \
    /var/www/html/frmwk/storage/framework/cache \
    /var/www/html/frmwk/storage/framework/views \
    /var/www/html/frmwk/storage/app/public \
    /var/www/html/frmwk/storage/logs \
    /var/www/html/frmwk/bootstrap/cache \
    /var/www/html/logs

chown -R www-data:www-data \
    /var/www/html/frmwk/storage \
    /var/www/html/frmwk/bootstrap/cache \
    /var/www/html/logs

APP_KEY_VALUE=$(grep -m1 '^APP_KEY=' /var/www/html/frmwk/.env 2>/dev/null | cut -d= -f2-)
if [ -z "$APP_KEY_VALUE" ]; then
    echo "[entrypoint] APP_KEY is not set — generating one now."
    php /var/www/html/frmwk/artisan key:generate --force 2>/dev/null || true
fi

php /var/www/html/frmwk/artisan package:discover --ansi 2>/dev/null || true

exec docker-php-entrypoint "$@"
