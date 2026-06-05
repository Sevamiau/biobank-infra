#!/bin/sh
set -e

BACKUP_DIR=/backups
KEEP_DAYS=7

while true; do
    FILENAME="cajassistema_$(date +%Y-%m-%d_%H-%M-%S).sql.gz"
    echo "[$(date)] Creating backup: $FILENAME"

    MYCNF=$(mktemp)
    chmod 600 "$MYCNF"
    printf '[client]\npassword=%s\n' "$DB_PASSWORD" >"$MYCNF"

    mysqldump \
        --defaults-file="$MYCNF" \
        -h "$DB_HOST" \
        -u "$DB_USERNAME" \
        --single-transaction \
        --add-drop-table \
        "$DB_DATABASE" | gzip >"$BACKUP_DIR/$FILENAME"

    rm -f "$MYCNF"

    find "$BACKUP_DIR" -name "cajassistema_*.sql.gz" -mtime +$KEEP_DAYS -delete
    echo "[$(date)] Rotation done. Next backup in 24h."

    sleep 86400
done
