WP_DATA = ./srcs/wordpress/data
DB_DATA = ./srcs/mariadb/data
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
	@docker stop $$(docker ps -qa)
	@docker rm $$(docker ps -qa)
	@docker rmi -f $$(docker images -qa) 
	@docker volume rm $$(docker volume ls -q) 
	@docker network rm $$(docker network ls -q) 
	@rm -rf $(WP_DATA)
	@rm -rf $(DB_DATA)

re: clean up

prune: clean
	@docker system prune -a --volumes -f