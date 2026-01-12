#!/bin/sh
set -e

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🚀 Starting WordPress setup..."

# Cargar variables de entorno desde /.env si existe
if [ -f "/.env" ]; then
  export $(grep -v '^#' /.env | xargs)
fi

# Esperar a que MariaDB esté lista (máx 3 intentos)
MAX_RETRIES=3
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

  chown -R www-data:www-data "$WP_PATH"

  # Crear wp-config.php
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

  # Crear usuario adicional
  wp user create "$WP_USER" "$WP_USER_EMAIL" \
    --user_pass="$WP_USER_PASS" \
    --role=author \
    --path="$WP_PATH" \
    --allow-root
else
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✔️ WordPress ya está configurado. Skipping setup."
fi

# 🔁 Recrear usuarios si se fuerza desde la variable de entorno
if [ "$FORCE_RECREATE_USERS" = "true" ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🔁 Recreating WordPress users..."

  # Eliminar admin si existe
  if wp user get "$WP_ADMIN" --path="$WP_PATH" --allow-root > /dev/null 2>&1; then
    wp user delete "$WP_ADMIN" --yes --allow-root --path="$WP_PATH"
    echo "🗑️  Usuario administrador '$WP_ADMIN' eliminado."
  fi

  # Eliminar user si existe
  if wp user get "$WP_USER" --path="$WP_PATH" --allow-root > /dev/null 2>&1; then
    wp user delete "$WP_USER" --yes --allow-root --path="$WP_PATH"
    echo "🗑️  Usuario normal '$WP_USER' eliminado."
  fi

  # Crear admin
  wp user create "$WP_ADMIN" "$WP_ADMIN_EMAIL" \
    --user_pass="$WP_ADMIN_PASS" \
    --role=administrator \
    --path="$WP_PATH" \
    --allow-root
  echo "✅ Usuario administrador '$WP_ADMIN' creado."

  # Crear usuario adicional
  wp user create "$WP_USER" "$WP_USER_EMAIL" \
    --user_pass="$WP_USER_PASS" \
    --role=author \
    --path="$WP_PATH" \
    --allow-root
  echo "✅ Usuario normal '$WP_USER' creado."
fi


echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🚀 Starting PHP-FPM..."
exec php-fpm81 -F
