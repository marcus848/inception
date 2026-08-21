FROM debian:12

RUN apt-get update && \
    apt-get install -y \
        php-cli \
        php-mysql \
        curl \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html && \
    curl -L https://www.adminer.org/latest.php -o /var/www/html/index.php

WORKDIR /var/www/html

CMD ["php", "-S", "0.0.0.0:8080", "index.php"]
