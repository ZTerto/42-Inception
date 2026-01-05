FROM alpine:3.18

# Declarar argumento que viene desde docker-compose
ARG DOMAIN_NAME
ENV DOMAIN_NAME=${DOMAIN_NAME}

# Instalar nginx y OpenSSL
RUN apk update && apk add --no-cache nginx openssl

# Crear carpetas necesarias
RUN mkdir -p /etc/nginx/ssl /run/nginx

# Copiar certificados SSL
COPY ./tools/zajodar.42.fr.crt /etc/nginx/ssl/zajodar.42.fr.crt
COPY ./tools/zajodar.42.fr.key /etc/nginx/ssl/zajodar.42.fr.key

# Copiar configuración de Nginx
COPY ./tools/default.conf /etc/nginx/http.d/default.conf

# (Opcional) Copiar nginx.conf personalizado si lo tienes
# COPY ./tools/nginx.conf /etc/nginx/nginx.conf

# (Opcional) Copiar entrypoint personalizado si lo usas
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 443

# Si no usas entrypoint.sh personalizado, puedes dejar solo:
# CMD ["nginx", "-g", "daemon off;"]
