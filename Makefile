COMPOSE_FILE = srcs/docker-compose.yml
	
all: up

up:
	if [ ! -d /home/ple-guya/data/mariadb ]; then \
		mkdir -p /home/ple-guya/data/mariadb /home/ple-guya/data/wordpress; \
	fi
	docker compose -f $(COMPOSE_FILE) up -d --build

down:
	docker compose -f $(COMPOSE_FILE) down

clean:
	docker compose -f $(COMPOSE_FILE) down -v
	docker system prune -af
	sudo rm -rf /home/ple-guya/data/*

ps:
	docker compose -f $(COMPOSE_FILE) ps

logs:
	docker compose -f $(COMPOSE_FILE) logs -f