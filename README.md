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

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Dockerfile Reference](https://docs.docker.com/reference/dockerfile/)
- [Docker Networking](https://docs.docker.com/engine/network/)
- [Docker Volumes](https://docs.docker.com/engine/storage/volumes/)
- [Docker Secrets](https://docs.docker.com/compose/how-tos/use-secrets/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [PHP-FPM Documentation](https://www.php.net/manual/en/install.fpm.php)
- [MariaDB Documentation](https://mariadb.com/docs/)
- [WordPress Documentation](https://wordpress.org/documentation/)
- [WP-CLI Documentation](https://wp-cli.org/)
- [Redis Documentation](https://redis.io/docs/latest/)
- [Adminer](https://www.adminer.org/)
- [vsftpd](https://security.appspot.com/vsftpd.html)

### AI usage

AI tool used: **ChatGPT (OpenAI)**.

AI was used as a learning and development assistant throughout the project. It was used to:

- Explain Docker concepts such as images, containers, Dockerfiles, networks, DNS, volumes, bind mounts and secrets.
- Explain the differences between Docker containers and virtual machines.
- Explain how NGINX, PHP-FPM, WordPress and MariaDB communicate with each other.
- Help understand TLS, HTTPS and the role of NGINX as the only entrypoint of the mandatory infrastructure.
- Help design and review Dockerfiles, Docker Compose configuration and initialization scripts.
- Help understand process management inside containers, including PID 1, `ENTRYPOINT`, `CMD` and `exec`.
- Assist with the configuration of MariaDB, WordPress, PHP-FPM and NGINX.
- Help debug build errors, container startup errors, permissions, networking and service connectivity.
- Assist with the bonus services: Redis cache, FTP, Adminer, static website and monitoring service.
- Review the implementation against the Inception subject and evaluation requirements.
- Suggest commands and procedures for manually testing containers, volumes, networks, persistence, TLS and database connectivity.
- Assist in writing and reviewing the project documentation.

AI suggestions were not treated as final implementations automatically. The generated explanations and code suggestions were reviewed, adapted and tested manually during development to ensure that the final infrastructure worked correctly and that its behavior was understood.