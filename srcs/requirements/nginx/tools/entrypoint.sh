#!/bin/sh

# Esperar a que el host "wordpress" esté disponible
until getent hosts wordpress > /dev/null; do
  echo "[nginx] ⏳ Esperando a que 'wordpress' esté listo..."
  sleep 2
done

echo "[nginx] ✅ WordPress está accesible. Iniciando Nginx..."
exec nginx -g "daemon off;"
