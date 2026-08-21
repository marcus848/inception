#!/bin/bash

set -e

FTP_PASSWORD=$(cat /run/secrets/ftp_password)

if ! id "$FTP_USER" >/dev/null 2>&1; then
    useradd -d /var/www/html -s /bin/bash "$FTP_USER"
fi

echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

# Keep the shared WordPress files writable by the WordPress service.
chown -R www-data:www-data /var/www/html
usermod -aG www-data "$FTP_USER"

exec "$@"
