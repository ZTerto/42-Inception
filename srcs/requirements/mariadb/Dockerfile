FROM alpine:3.18

# Mariadb instalation
RUN apk update && apk add --no-cache \
    mariadb mariadb-client mariadb-openrc bash

# Create mysql user and group
RUN mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Copy entrypoint script
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy custom configuration file
COPY tools/my_conf.cnf /etc/my.cnf.d/my_conf.cnf
RUN chmod 644 /etc/my.cnf.d/my_conf.cnf

ENTRYPOINT ["/entrypoint.sh"]
