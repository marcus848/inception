# User Documentation

## Services

The project provides a WordPress website through NGINX over HTTPS.

Mandatory services:

- NGINX
- WordPress + PHP-FPM
- MariaDB

Bonus services:

- Redis object cache
- FTP server
- Adminer
- Static website
- Infrastructure monitor

## Start and stop

From the repository root:

```bash
make
```

To stop the infrastructure:

```bash
make down
```

To start existing stopped containers:

```bash
make start
```

To see the running services:

```bash
make ps
```

To follow logs:

```bash
make logs
```

## Access

- WordPress: `https://marcudos.42.fr`
- WordPress admin: `https://marcudos.42.fr/wp-admin`
- Adminer: `http://localhost:8080`
- Static website: `http://localhost:8081`
- Monitor: `http://localhost:8082`
- FTP: port `21`

The HTTPS certificate is self-signed, so the browser may display a security warning.

## Credentials

Configuration is stored in `srcs/.env`. Passwords are stored separately in the `secrets/` directory and must not be committed to Git.

Required secret files:

- `db_password.txt`
- `db_root_password.txt`
- `wp_admin_password.txt`
- `wp_user_password.txt`
- `ftp_password.txt`

## Check the services

```bash
docker ps
```

All project containers should be running. For detailed logs:

```bash
docker compose -f srcs/docker-compose.yml logs
```

The monitor at `http://localhost:8082` also shows the availability of the main internal services.
