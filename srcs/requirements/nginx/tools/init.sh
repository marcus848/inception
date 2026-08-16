#!/bin/bash

set -e

mkdir -p /etc/nginx/ssl

if [ ! -f /etc/nginx/ssl/inception.crt ]; then

    echo "Generating TLS certificate..."

    openssl req \
        -x509 \
        -nodes \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -days 365 \
        -subj "/C=BR/ST=SP/L=SaoPaulo/O=42/CN=${DOMAIN_NAME}"

fi

exec "$@"