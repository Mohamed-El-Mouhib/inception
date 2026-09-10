COMPOSE_PATH = ./srcs/docker-compose.yml
DB_DATA_DIR = /home/mel-mouh/data/db
WP_DATA_DIR = /home/mel-mouh/data/wordpress

all: up

up: $(DB_DATA_DIR) $(WP_DATA_DIR)
	docker compose -f $(COMPOSE_PATH) up --build

$(WP_DATA_DIR):
	mkdir -p $(WP_DATA_DIR)

$(DB_DATA_DIR):
	mkdir -p $(DB_DATA_DIR)

down:
	docker compose -f $(COMPOSE_PATH) down

clean: down

fclean: clean
	- docker rmi -f `docker images -qa` 2>/dev/null
	- docker volume rm `docker volume ls -q` 2>/dev/null

re: fclean up
