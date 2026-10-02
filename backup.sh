#!/usr/bin/env bash
# Back up the database and wp-content (uploads, themes, plugins).
# Run on the Droplet from the repo directory. Keeps the last 14 backups.
set -euo pipefail

cd "$(dirname "$0")"
DEST=/opt/backups/jackgannaway
STAMP=$(date +%Y%m%d-%H%M%S)
mkdir -p "$DEST"

# shellcheck disable=SC1091
source .env

docker compose exec -T -e MYSQL_PWD="$DB_PASSWORD" db \
  mariadb-dump -u wordpress --single-transaction wordpress \
  | gzip > "$DEST/db-$STAMP.sql.gz"

docker compose exec -T wordpress tar -C /var/www/html -czf - wp-content \
  > "$DEST/wp-content-$STAMP.tar.gz"

# Refuse to call an empty dump a backup.
[ "$(gzip -cd "$DEST/db-$STAMP.sql.gz" | grep -c 'CREATE TABLE')" -gt 0 ] \
  || { echo "backup FAILED: database dump has no tables" >&2; exit 1; }

ls -1t "$DEST"/db-*.sql.gz | tail -n +15 | xargs -r rm --
ls -1t "$DEST"/wp-content-*.tar.gz | tail -n +15 | xargs -r rm --
echo "backup ok: $DEST/*-$STAMP.*"
