FROM alpine:3.18

# Instalar PHP, WP-CLI y dependencias
RUN apk update && apk add --no-cache \
  bash \
  php81 \
  php81-fpm \
  php81-mysqli \
  php81-curl \
  php81-json \
  php81-mbstring \
  php81-opcache \
  php81-gd \
  php81-dom \
  php81-exif \
  php81-fileinfo \
  php81-tokenizer \
  php81-pecl-imagick \
  php81-session \
  php81-phar \
  php81-zlib \
  php81-xml \
  php81-ctype \
  php81-iconv \
  php81-simplexml \
  curl \
  wget \
  mariadb-client \
  su-exec \
  tzdata

# Directorio de trabajo
WORKDIR /var/www

# Crear el usuario y grupo www-data
RUN adduser -S -u 82 -G www-data www-data || true

# Instalar WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Configurar PHP-FPM para escuchar en todas las interfaces
RUN sed -i 's|listen = 127.0.0.1:9000|listen = 0.0.0.0:9000|' /etc/php81/php-fpm.d/www.conf

# Copiar entrypoint
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["/entrypoint.sh"]
