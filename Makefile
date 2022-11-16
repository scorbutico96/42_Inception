RED = \033[31m
GREEN = \033[32m
BLUE = \033[34m
RESET = \033[0m
LOG = echo "$(BLUE)MAKE LOG$(RESET) "

up: volumes
	@$(LOG)Running composition
	@docker-compose -f ./srcs/docker-compose.yml up -d

build: volumes
	@$(LOG)Building composition
	@docker-compose -f ./srcs/docker-compose.yml build

volumes:
	@mkdir -p ~/data/db-data
	@mkdir -p ~/data/wp-data

stop:
	@$(LOG)Stopping composition
	@docker-compose -f ./srcs/docker-compose.yml stop

down:
	@$(LOG)Composition down
	@docker-compose -f ./srcs/docker-compose.yml down

restart: stop up

deletevolumes: down
	@echo -n "$(RED)DELETE VOLUMES? [y/N] $(RESET)"
	@read line; \
	if [ "$$line" != "y" ]; then \
		$(LOG)Volumes deletion aborted; \
	else \
	$(LOG)Volumes deleted && sudo rm -rf ~/data; \
	fi

prune: down
	@$(LOG)Prune docker
	@docker system prune -a

destroy: deletevolumes prune

status:
	@echo "$(GREEN)Docker Containers$(RESET)"
	@docker ps -a
	@echo "$(GREEN)Docker Images$(RESET)"
	@docker images

logs:
	@docker-compose -f ./srcs/docker-compose.yml logs -f --tail="all"