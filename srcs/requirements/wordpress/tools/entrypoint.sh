#!/bin/sh
set -e
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🚀 Starting WordPress setup..."

# loading environment variables from /.env file
if [ -f "/.env" ]; then
  export $(grep -v '^#' /.env | xargs)
fi
mkdir -p "$WP_PATH"

# wait for MariaDB to be ready
MAX_RETRIES=10
echo "[$(date '+%Y-%m-%d %H:%M:%S')] ⏳ Waiting for MariaDB to be ready..."
i=1
until mysqladmin ping -h"${DB_HOST%%:*}" -u"${DB_USER}" -p"${DB_PASS}" --silent; do
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🔁 Attempt $i: MariaDB not ready yet..."
  i=$((i + 1))
  if [ "$i" -gt "$MAX_RETRIES" ]; then
    echo "❌ Failed to connect to MariaDB after $MAX_RETRIES attempts."
    exit 1
  fi
  sleep 2
done

# configure WordPress if not already configured
if [ ! -f "${WP_PATH}/wp-config.php" ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🔧 Configurando WordPress..."
  chown -R www-data:www-data "$WP_PATH"

  if [ ! -f "${WP_PATH}/wp-load.php" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 📥 Downloading WordPress core..."
    wp core download \
      --path="$WP_PATH" \
      --allow-root
  fi

  wp core config \
    --path="$WP_PATH" \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASS" \
    --dbhost="$DB_HOST" \
    --allow-root

  wp core install \
    --path="$WP_PATH" \
    --url="$WP_URL" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN" \
    --admin_password="$WP_ADMIN_PASS" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --allow-root

  wp user create "$WP_USER" "$WP_USER_EMAIL" \
    --user_pass="$WP_USER_PASS" \
    --role=author \
    --path="$WP_PATH" \
    --allow-root
else
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✔️ WordPress ya está configurado. Skipping setup."
fi

# recreate users if FORCE_RECREATE_USERS is true
if [ "$FORCE_RECREATE_USERS" = "true" ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🔁 Recreating WordPress users..."

  if wp user get "$WP_ADMIN" --path="$WP_PATH" --allow-root > /dev/null 2>&1; then
    wp user delete "$WP_ADMIN" --yes --allow-root --path="$WP_PATH"
  fi

  if wp user get "$WP_USER" --path="$WP_PATH" --allow-root > /dev/null 2>&1; then
    wp user delete "$WP_USER" --yes --allow-root --path="$WP_PATH"
  fi

  wp user create "$WP_ADMIN" "$WP_ADMIN_EMAIL" \
    --user_pass="$WP_ADMIN_PASS" \
    --role=administrator \
    --path="$WP_PATH" \
    --allow-root

  wp user create "$WP_USER" "$WP_USER_EMAIL" \
    --user_pass="$WP_USER_PASS" \
    --role=author \
    --path="$WP_PATH" \
    --allow-root
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🚀 Starting PHP-FPM..."
exec php-fpm81 -F
