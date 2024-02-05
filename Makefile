EXIST := $(shell if [ -d "./www/www.php.com" ]; then echo "exist"; else echo "notexist"; fi)

MODEL ?=

TABLE ?=

all: help

help: 
	@echo "支持以下命令"
	@echo "make up                      # 创建镜像，生成容器"
	@echo "make ps                      # 查看容器"
	@echo "make down                    # 删除容器"
	@echo "make laravel                 # 创建一个 laravel 项目"
	@echo "make model MODEL=xxx         # 创建一个模型和迁移"
	@echo "make table TABLE=xxx         # 创建一个迁移"
	@echo "make migrate                 # 执行迁移，创建数据库表"

up:
	@docker-compose up -d
	@chmod 777 ./logs/redis

ps:
	@docker-compose ps

down:
	@docker-compose down

laravel:
ifeq ($(EXIST),notexist)
	@con=$$(docker ps -qf "name=mg-php8.3"); \
	if [ -n "$$con" ]; then \
		docker exec -i $$con bash -c 'cd /www && ls && composer create-project laravel/laravel --prefer-dist www.php.com'; \
	else \
		echo "没找到 php 容器"; \
	fi
endif

model:
ifdef MODEL
	@con=$$(docker ps -qf "name=mg-php8.3"); \
	if [ -n "$$con" ]; then \
		docker exec -i $$con bash -c "cd /www/www.php.com && php artisan make:model $(MODEL) -m"; \
	else \
		echo "没找到 php 容器"; \
	fi
else 
	@echo "请加上 MODEL 参数"
endif

table:
ifdef TABLE
	@con=$$(docker ps -qf "name=mg-php8.3"); \
	if [ -n "$$con" ]; then \
		docker exec -i $$con bash -c "cd /www/www.php.com && php artisan make:migration create_$(TABLE)_table --create=$(TABLE)"; \
	else \
		echo "没找到 php 容器"; \
	fi
else
	@echo "请加上 TABLE 参数"
endif

migrate:
	@con=$$(docker ps -qf "name=mg-php8.3"); \
	if [ -n "$$con" ]; then \
		docker exec -i $$con bash -c "cd /www/www.php.com && php artisan migrate:fresh"; \
	else \
		echo "没找到 php 容器"; \
	fi