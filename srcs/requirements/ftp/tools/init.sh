#!/bin/bash

set -e

FTP_PASSWORD=$(cat /run/secrets/ftp_password)
FTP_PASV_ADDRESS=${FTP_PASV_ADDRESS:-127.0.0.1}

if ! id "$FTP_USER" >/dev/null 2>&1; then
    useradd -M -d /var/www/html -s /bin/bash -g www-data "$FTP_USER"
fi

echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

chown -R www-data:www-data /var/www/html
chmod -R g+rwX /var/www/html

if ! grep -q '^pasv_address=' /etc/vsftpd.conf; then
    echo "pasv_address=$FTP_PASV_ADDRESS" >> /etc/vsftpd.conf
fi

exec "$@"
