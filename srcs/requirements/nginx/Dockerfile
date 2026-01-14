FROM alpine:3.18

ARG DOMAIN_NAME
ENV DOMAIN_NAME=${DOMAIN_NAME}

RUN apk update && apk add --no-cache nginx openssl

RUN mkdir -p /etc/nginx/ssl /run/nginx

# Copiar SOLO la config de nginx
COPY ./tools/default.conf /etc/nginx/http.d/default.conf

# Copiar entrypoint
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]
