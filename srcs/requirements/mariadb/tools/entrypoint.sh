#!/bin/sh
set -e

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🚀 Initializing MariaDB setup..."

MYSQL_DATABASE="wordpress"
MYSQL_USER="wp_user"
MYSQL_PASSWORD="wp_pass"
MYSQL_ROOT_PASSWORD="rootpass"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] 📦 MariaDB data not found. Initializing..."
  mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql > /dev/null

  echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🔧 Setting up database and users..."

  mysqld --user=mysql --bootstrap <<-EOSQL
    FLUSH PRIVILEGES;
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8 COLLATE utf8_general_ci;

    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL

  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ MariaDB database initialized."
else
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✔️ MariaDB data already present. Skipping initialization."
fi

# ✅ Sin pasar flags (ya están en my_conf.cnf)
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🚀 Starting MariaDB server..."
exec mariadbd --user=mysql --console --port=3306 --bind-address=0.0.0.0
