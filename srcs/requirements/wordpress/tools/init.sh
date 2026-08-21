#!/bin/bash

set -e

mkdir -p /run/php
mkdir -p /var/www/html

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

echo "Waiting for MariaDB..."

until mariadb-admin ping \
    -h mariadb \
    -u "$MYSQL_USER" \
    -p"$DB_PASSWORD" \
    --silent
do
    sleep 2
done

echo "MariaDB is ready."

if [ ! -f /var/www/html/wp-config.php ]; then

    echo "Installing WordPress..."

    wp core download \
        --allow-root

    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="mariadb:3306" \
        --allow-root

    wp core install \
        --url="https://$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    wp user create \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=subscriber \
        --allow-root

    echo "WordPress installed."

fi

echo "Waiting for Redis..."
until redis-cli -h redis ping 2>/dev/null | grep -q PONG
do
    sleep 2
done
echo "Redis is ready."

wp config set WP_REDIS_HOST redis --type=constant --allow-root
wp config set WP_REDIS_PORT 6379 --raw --type=constant --allow-root

if ! wp plugin is-installed redis-cache --allow-root; then
    wp plugin install redis-cache --activate --allow-root
elif ! wp plugin is-active redis-cache --allow-root; then
    wp plugin activate redis-cache --allow-root
fi

wp redis enable --allow-root

chown -R www-data:www-data /var/www/html

exec "$@"