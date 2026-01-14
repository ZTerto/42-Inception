#!/bin/sh
set -e

SSL_DIR="/etc/nginx/ssl"
CRT="$SSL_DIR/server.crt"
KEY="$SSL_DIR/server.key"

# Generar certificados SOLO si no existen (persistencia)
if [ ! -f "$CRT" ] || [ ! -f "$KEY" ]; then
    echo "🔐 Generando certificado SSL para $DOMAIN_NAME..."
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME}" \
        -keyout "$KEY" \
        -out "$CRT"
else
    echo "🔐 Certificados SSL ya existen, reutilizando."
fi

# Lanzar nginx en primer plano (PID 1)
echo "🚀 Iniciando NGINX..."
exec nginx -g "daemon off;"
