*This project has been created as part of the 42 curriculum by marcudos.*

# Inception

## Description

Inception is a system administration project focused on Docker. The infrastructure runs inside a virtual machine and is orchestrated with Docker Compose.

The mandatory stack contains:

- NGINX as the HTTPS entrypoint using TLS 1.2/1.3.
- WordPress with PHP-FPM.
- MariaDB as the database.
- A private Docker network.
- Persistent storage for WordPress and MariaDB.

Bonus services: Redis cache, FTP, Adminer, a static website and a simple service monitor.

## Design choices

### Virtual Machines vs Docker

A virtual machine runs a complete operating system with its own kernel. Docker containers share the host kernel and isolate individual services, making them lighter. In this project Docker runs inside a VM.

### Secrets vs Environment Variables

Environment variables store non-sensitive configuration such as usernames, database names and the domain. Passwords are stored in secret files and mounted inside containers under `/run/secrets/`.

### Docker Network vs Host Network

The project uses a custom bridge network. Containers communicate through Docker DNS using service names such as `mariadb`, `wordpress` and `redis`. Host networking is not used.

### Docker Volumes vs Bind Mounts

Volumes persist data independently from containers. In this project the named volumes use bind mounts backed by `/home/marcudos/data/mariadb` and `/home/marcudos/data/wordpress`.

## Instructions

Create `srcs/.env` using `srcs/.env.example` as reference and create the required password files inside `secrets/`.

Build and start the project from the repository root:

```bash
make
```

Useful commands:

```bash
make down     # stop and remove the containers
make start    # start existing containers
make stop     # stop containers
make logs     # follow logs
make ps       # show services
make clean    # remove containers and orphans
make fclean   # remove containers, images, volumes and persistent project data
make re       # clean everything and rebuild
```

WordPress is available at `https://marcudos.42.fr`.

Bonus services:

- Adminer: `http://localhost:8080`
- Static website: `http://localhost:8081`
- Monitor: `http://localhost:8082`
- FTP: port `21`

More information is available in [USER_DOC.md](USER_DOC.md) and [DEV_DOC.md](DEV_DOC.md).

## Resources

Documentation used during development:

- Docker documentation
- Docker Compose documentation
- NGINX documentation
- MariaDB documentation
- WordPress and WP-CLI documentation
- Redis documentation
- vsftpd documentation

### AI usage

AI was used as a learning and development assistant to explain Docker concepts, review configuration files and scripts, help debug errors, review the project requirements and assist with documentation. All suggestions were reviewed and tested during development.
