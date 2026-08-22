# Developer Documentation

## Requirements

The project runs inside a Linux virtual machine and requires:

- Docker
- Docker Compose
- Make

The domain `marcudos.42.fr` must resolve to the VM, for example through `/etc/hosts`.

## Configuration

Create the environment file:

```bash
cp srcs/.env.example srcs/.env
```

Fill in the required values without committing the real `.env` file.

Create the password files in `secrets/`:

```text
db_password.txt
db_root_password.txt
wp_admin_password.txt
wp_user_password.txt
ftp_password.txt
```

Each file contains only its password.

## Build and launch

From the repository root:

```bash
make
```

The Makefile creates:

```text
/home/marcudos/data/mariadb
/home/marcudos/data/wordpress
```

and then builds and starts the services with Docker Compose.

## Architecture

```text
Client
  |
 HTTPS :443
  |
 NGINX
  |
 FastCGI :9000
  |
WordPress/PHP-FPM
  |
 MariaDB :3306
```

All containers communicate through the custom `inception` Docker network. Docker DNS allows containers to use service names instead of fixed IP addresses.

WordPress files and MariaDB data are persisted outside the container lifecycle using Docker volumes backed by `/home/marcudos/data/`.

## Container management

```bash
make ps
make logs
make stop
make start
make restart
make down
```

To rebuild everything from scratch:

```bash
make re
```

Warning: `make fclean` also removes the persistent project data under `/home/marcudos/data/mariadb` and `/home/marcudos/data/wordpress`.

## Useful debugging commands

```bash
docker ps
docker images
docker volume ls
docker network ls
docker compose -f srcs/docker-compose.yml logs
docker exec -it mariadb bash
docker exec -it wordpress bash
```

To verify Redis object caching:

```bash
docker exec wordpress wp redis status --allow-root
```

To inspect the MariaDB database:

```bash
docker exec -it mariadb bash
mariadb -u root -p
```

Then inside MariaDB:

```sql
SHOW DATABASES;
USE wordpress;
SHOW TABLES;
SELECT ID, user_login, user_email FROM wp_users;
```
