COMPOSE_FILE = srcs/docker-compose.yml
USER = ple-guya
DOMAIN = $(USER).42.fr

all: up

up:
	@if [ ! -d /home/$(USER)/data/mariadb ]; then \
		mkdir -p /home/$(USER)/data/mariadb /home/$(USER)/data/wordpress; \
	fi
	@if ! grep -q "$(DOMAIN)" /etc/hosts; then \
		echo "127.0.0.1 $(DOMAIN)" | sudo tee -a /etc/hosts; \
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