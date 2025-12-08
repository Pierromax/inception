#!/bin/bash
set -e

DB_PATH="/var/lib/mysql"
DB_INIT_FLAG="${DB_PATH}/.db_initialized"

if [ -d "${DB_PATH}/mysql" ] && [ -f "${DB_INIT_FLAG}" ]; then
    echo "[mariadb] Existing database detected, skipping initialization."
else
    echo "[mariadb] Starting temporary mysqld for initialization..."
    mysqld_safe --skip-networking &
    pid="$!"

    echo "[mariadb] Waiting for mysqld to start..."
    until mysqladmin ping --silent; do
        sleep 1
    done

    echo "[mariadb] Creating database and user..."
    mysql -u root <<-EOSQL
		CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
		CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
		GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
		FLUSH PRIVILEGES;
EOSQL

    echo "[mariadb] Shutting down temporary mysqld..."
    mysqladmin shutdown

    touch "${DB_INIT_FLAG}"
    echo "[mariadb] Initialization complete."
	ls /var/lib/mysql
fi

CONF_FILE="/etc/mysql/mariadb.conf.d/50-server.cnf"
if grep -q '^bind-address' "$CONF_FILE"; then
    sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' "$CONF_FILE"
else
    echo "bind-address = 0.0.0.0" >> "$CONF_FILE"
fi

echo "[mariadb] Starting MariaDB..."
exec mysqld_safe
exec mysqld_safe