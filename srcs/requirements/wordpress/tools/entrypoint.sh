#!/bin/sh
set -e

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🚀 Starting WordPress setup..."

# ⚙️ Variables hardcodeadas (puedes sustituir por ENV si prefieres)
DB_NAME="wordpress"
DB_USER="wp_user"
DB_PASS="wp_pass"
DB_HOST="mariadb:3306"

WP_PATH="/var/www/wordpress"
WP_URL="https://zajodar.42.fr"
WP_TITLE="ZT WordPress"
WP_ADMIN="zt_admin"
WP_ADMIN_PASS="wpadminpass"
WP_ADMIN_EMAIL="admin@example.com"

WP_USER="wpuser"
WP_USER_EMAIL="wpuser@example.com"
WP_USER_PASS="wpuserpass"

# Esperar a que MariaDB esté lista (máx 30 intentos)
MAX_RETRIES=30
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

# Configurar WordPress si no está ya configurado
if [ ! -f "${WP_PATH}/wp-config.php" ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🔧 Configurando WordPress..."

  # Asegurar que el directorio tiene permisos correctos
  chown -R www-data:www-data "$WP_PATH"

  # Configurar wp-config.php
  wp core config \
    --path="$WP_PATH" \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASS" \
    --dbhost="$DB_HOST" \
    --allow-root

  # Instalar WordPress
  wp core install \
    --path="$WP_PATH" \
    --url="$WP_URL" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN" \
    --admin_password="$WP_ADMIN_PASS" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --allow-root

  # Crear un usuario adicional (autor)
  wp user create "$WP_USER" "$WP_USER_EMAIL" \
    --user_pass="$WP_USER_PASS" \
    --role=author \
    --path="$WP_PATH" \
    --allow-root
else
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✔️ WordPress ya está configurado. Skipping."
fi

# Iniciar PHP-FPM en primer plano
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🚀 Starting PHP-FPM..."
exec php-fpm81 -F
