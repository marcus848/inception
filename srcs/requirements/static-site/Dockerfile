FROM debian:12

RUN apt-get update && \
    apt-get install -y python3 && \
    rm -rf /var/lib/apt/lists/*

COPY site/ /var/www/html/

WORKDIR /var/www/html

CMD ["python3", "-m", "http.server", "8081", "--bind", "0.0.0.0"]
