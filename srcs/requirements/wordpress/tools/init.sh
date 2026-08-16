#!/bin/bash

set -e

mkdir -p /run/php
mkdir -p /var/www/html

chown -R www-data:www-data /var/www/html

exec "$@"