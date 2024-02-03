ARG IMAGE
FROM ${IMAGE}

# zip 扩展
RUN apt-get update && apt-get install -y libzip-dev && docker-php-ext-install zip

# 安装 mysql
RUN docker-php-ext-install pdo pdo_mysql && docker-php-ext-install mysqli

# redis 扩展
RUN pecl install redis && docker-php-ext-enable redis

# 安装 composer，并设置镜像
RUN curl -o /usr/bin/composer https://mirrors.aliyun.com/composer/composer.phar \ 
    && chmod +x /usr/bin/composer \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer

WORKDIR /www