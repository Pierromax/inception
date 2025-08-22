WP_DATA = /home/data/wordpress
DB_DATA = /home/data/mariadb
DCKF_COMPOSE = ./srcs/docker-compose.yml

all: up

up: build
	@mkdir -p $(WP_DATA)
	@mkdir -p $(DB_DATA)
	docker compose -f $(DCKF_COMPOSE) up -d

down:
	docker compose -f $(DCKF_COMPOSE) down

stop:
	docker compose -f $(DCKF_COMPOSE) stop

start:
	docker compose -f $(DCKF_COMPOSE) start

build:
	docker compose -f $(DCKF_COMPOSE) build

clean:
	@docker stop $$(docker ps -qa) || true
	@docker rm $$(docker ps -qa) || true
	@docker rmi -f $$(docker images -qa) || true
	@docker volume rm $$(docker volume ls -q) || true
	@docker network rm $$(docker network ls -q) || true
	@rm -rf $(WP_DATA) || true
	@rm -rf $(DB_DATA) || true

re: clean up

prune: clean
	@docker system prune -a --volumes -f