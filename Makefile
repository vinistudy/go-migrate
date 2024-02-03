EXIST := $(shell if [ -d "./www/www.php.com" ]; then echo "exist"; else echo "notexist"; fi)

all: help

help: 
	@echo "支持以下命令"
	@echo "make up            # 启动项目"
	@echo "make down          # 停止项目"
	@echo "make laravel       # 创建一个 laravel 项目"

up:
	@echo "启动服务"
	@docker-compose up -d
	@chmod 777 ./logs/redis

laravel:
ifeq ($(EXIST),notexist)
	@con=$$(docker ps -qf "name=mg-php8.3"); \
	echo "php container id: $$con"; \
	if [ -n "$$con" ]; then \
		docker exec -i $$con bash -c 'cd /www && ls && composer create-project laravel/laravel --prefer-dist www.php.com'; \
		echo "create laravel project complete"; \
	else \
		echo "php container not found"; \
	fi
endif

down:
	@docker-compose down
