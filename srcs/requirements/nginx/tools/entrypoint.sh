#!/bin/sh
set -e

# Load environment variables from /.env file
SSL_DIR="/etc/nginx/ssl"
CRT="$SSL_DIR/server.crt"
KEY="$SSL_DIR/server.key"

# Ensure SSL directory exists
if [ ! -f "$CRT" ] || [ ! -f "$KEY" ]; then
    echo "🔐 Generating SSL certificate for $DOMAIN_NAME..."
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME}" \
        -keyout "$KEY" \
        -out "$CRT"
else
    echo "🔐 if certificates already exist, reusing them."
fi

echo "🚀 Iniciando NGINX..."
exec nginx -g "daemon off;"
