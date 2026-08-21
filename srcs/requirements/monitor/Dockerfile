FROM debian:12

RUN apt-get update && \
    apt-get install -y python3 && \
    rm -rf /var/lib/apt/lists/*

COPY app/server.py /app/server.py

WORKDIR /app

CMD ["python3", "server.py"]
