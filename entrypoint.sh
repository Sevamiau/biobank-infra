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

# Bootstrap first admin if no ADM user exists yet (H-01).
php -r "
    \$host = getenv('DB_HOST') ?: 'db';
    \$port = getenv('DB_PORT') ?: '3306';
    \$db   = getenv('DB_DATABASE') ?: 'cajassistema';
    \$user = getenv('DB_USERNAME') ?: '';
    \$pass = getenv('DB_PASSWORD') ?: '';
    if (!\$user) { echo '[entrypoint] DB_USERNAME not set, skipping admin bootstrap.' . PHP_EOL; exit(0); }
    try {
        \$pdo = new PDO(
            \"mysql:host=\$host;port=\$port;dbname=\$db;charset=utf8mb4\",
            \$user, \$pass,
            [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
        );
        \$count = (int)\$pdo->query(\"SELECT COUNT(*) FROM usuarios WHERE permiso = 'ADM'\")->fetchColumn();
        if (\$count > 0) { exit(0); }
        \$password = rtrim((string)shell_exec('openssl rand -base64 16'));
        \$hash = password_hash(\$password, PASSWORD_BCRYPT);
        \$stmt = \$pdo->prepare('INSERT INTO usuarios (username, password, email, permiso, must_change_password) VALUES (:u, :h, :e, :p, 1)');
        \$stmt->execute([':u' => 'admin', ':h' => \$hash, ':e' => 'admin@local.dev', ':p' => 'ADM']);
        echo '[entrypoint] ============================================================' . PHP_EOL;
        echo '[entrypoint]  First admin created.' . PHP_EOL;
        echo '[entrypoint]  Username : admin' . PHP_EOL;
        echo '[entrypoint]  Password : ' . \$password . PHP_EOL;
        echo '[entrypoint]  Change this password immediately after first login.' . PHP_EOL;
        echo '[entrypoint] ============================================================' . PHP_EOL;
    } catch (Throwable \$e) {
        echo '[entrypoint] Admin bootstrap failed: ' . \$e->getMessage() . PHP_EOL;
    }
" || true

exec docker-php-entrypoint "$@"
