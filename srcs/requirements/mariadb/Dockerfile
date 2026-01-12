FROM alpine:3.18

RUN apk update && apk add --no-cache \
    mariadb mariadb-client mariadb-openrc bash

RUN mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 👇 Esta línea es CLAVE para usar el archivo my_conf.cnf
COPY tools/my_conf.cnf /etc/my.cnf.d/my_conf.cnf

# ⚠️ Importante: quitar permisos peligrosos para que no sea ignorado
RUN chmod 644 /etc/my.cnf.d/my_conf.cnf

ENTRYPOINT ["/entrypoint.sh"]
