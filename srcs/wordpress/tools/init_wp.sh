#!/bin/bash
set -e

WP_PATH="/var/www/html"

mkdir -p /run/php
mkdir -p "$WP_PATH"

echo "[wordpress] Waiting for MariaDB to be ready..."
while ! mysqladmin ping -h"${MYSQL_HOST}" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent; do
    sleep 2
done
echo "[wordpress] MariaDB is ready!"

# Installation de WordPress
if [ ! -f "${WP_PATH}/wp-config.php" ]; then
    echo "[wordpress] Downloading WordPress..."
    cd "$WP_PATH"
    wp core download --allow-root

    echo "[wordpress] Creating wp-config.php..."
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="${MYSQL_HOST}:3306" \
        --allow-root
fi

# Installation WP si non installée
if ! wp core is-installed --path="$WP_PATH" --allow-root; then
    echo "[wordpress] Installing WordPress..."
    wp core install \
        --url="${WP_URL}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root

    echo "[wordpress] Creating additional user..."
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=editor \
        --allow-root
else
    echo "[wordpress] WordPress already installed."
fi

# Permissions
chown -R www-data:www-data "$WP_PATH"
chmod -R 755 "$WP_PATH"

echo "[wordpress] Configuring PHP-FPM to listen on port 9000..."
sed -i "s|^listen = .*|listen = 9000|" /etc/php/8.2/fpm/pool.d/www.conf

echo "[wordpress] Starting PHP-FPM..."
exec php-fpm8.2 -F
