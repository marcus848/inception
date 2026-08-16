COMPOSE = docker compose -f srcs/docker-compose.yml

DATA_DIR = /home/$(USER)/data
MARIADB_DIR = $(DATA_DIR)/mariadb
WORDPRESS_DIR = $(DATA_DIR)/wordpress

all: up

prepare:
	mkdir -p $(MARIADB_DIR)
	mkdir -p $(WORDPRESS_DIR)

up: prepare
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

start:
	$(COMPOSE) start

stop:
	$(COMPOSE) stop

restart:
	$(COMPOSE) restart

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

clean:
	$(COMPOSE) down --remove-orphans

fclean:
	$(COMPOSE) down --rmi all --volumes --remove-orphans
	sudo rm -rf $(MARIADB_DIR)
	sudo rm -rf $(WORDPRESS_DIR)

re: fclean all

.PHONY: all prepare up down start stop restart logs ps clean fclean re