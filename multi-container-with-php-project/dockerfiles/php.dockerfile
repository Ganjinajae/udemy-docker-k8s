FROM php:7.4-fpm-alpine

WORKDIR /var/www/html

RUN docker-php-ext-install pdo pdo_mysql

# ENTRYPOINT, CMD를 따로 명시하지 않으면 기본 image에 있는 명령들이 수행 됨