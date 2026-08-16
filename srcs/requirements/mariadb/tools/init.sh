#!/bin/bash

set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

if [ ! -d "/var/lib/mysql/mysql" ]; then

    echo "Initializing MariaDB..."

    mariadb-install-db \
        --user=mysql \
        --datadir=/var/lib/mysql

    gosu mysql mariadbd \
        --skip-networking \
        --socket=/run/mysqld/mysqld.sock &

    pid="$!"

    until mariadb-admin \
        --socket=/run/mysqld/mysqld.sock \
        ping --silent
    do
        sleep 1
    done

    mariadb \
        --socket=/run/mysqld/mysqld.sock <<EOF

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%'
IDENTIFIED BY '${DB_PASSWORD}';

GRANT ALL PRIVILEGES
ON \`${MYSQL_DATABASE}\`.*
TO '${MYSQL_USER}'@'%';

ALTER USER 'root'@'localhost'
IDENTIFIED BY '${DB_ROOT_PASSWORD}';

FLUSH PRIVILEGES;

EOF

    mariadb-admin \
        -u root \
        -p"${DB_ROOT_PASSWORD}" \
        --socket=/run/mysqld/mysqld.sock \
        shutdown

    wait "$pid"

    echo "MariaDB initialized."

fi

exec gosu mysql "$@"