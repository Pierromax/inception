#!/bin/bash
set -e

# Avoid client env forcing TCP to the service name; use local socket instead
unset MYSQL_HOST

DB_PATH="/var/lib/mysql"
DB_INIT_FLAG="${DB_PATH}/.db_initialized"

# Permissions nécessaires
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ ! -d "${DB_PATH}/mysql" ] || [ ! -f "${DB_INIT_FLAG}" ]; then
    echo "[mariadb] First initialization..."

    mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
    pid="$!"

    echo "[mariadb] Waiting for mysqld to start..."
    until mysqladmin --socket=/run/mysqld/mysqld.sock ping --silent; do
        sleep 1
    done

    echo "[mariadb] Creating database and user..."
    mysql --socket=/run/mysqld/mysqld.sock -u root <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        FLUSH PRIVILEGES;
EOSQL

    echo "[mariadb] Stopping temporary mysqld..."
    mysqladmin --socket=/run/mysqld/mysqld.sock shutdown

    touch "${DB_INIT_FLAG}"
    echo "[mariadb] Initialization done."
fi

# Configure l'écoute externe
cat > /etc/mysql/mariadb.conf.d/50-server.cnf <<EOF
[mysqld]
bind-address = 0.0.0.0
EOF

echo "[mariadb] Starting MariaDB..."
exec mysqld --user=mysql
