import socket
from http.server import BaseHTTPRequestHandler, HTTPServer

SERVICES = {
    "WordPress": ("wordpress", 9000),
    "MariaDB": ("mariadb", 3306),
    "Redis": ("redis", 6379),
    "Adminer": ("adminer", 8080),
}


def is_up(host, port):
    try:
        with socket.create_connection((host, port), timeout=1):
            return True
    except OSError:
        return False


class StatusHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        rows = "".join(
            f"<li>{name}: <strong>{'UP' if is_up(host, port) else 'DOWN'}</strong></li>"
            for name, (host, port) in SERVICES.items()
        )

        page = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inception Status</title>
</head>
<body>
    <h1>Inception Status</h1>
    <ul>{rows}</ul>
</body>
</html>
"""
        body = page.encode("utf-8")
        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, format, *args):
        return


if __name__ == "__main__":
    HTTPServer(("0.0.0.0", 8082), StatusHandler).serve_forever()
