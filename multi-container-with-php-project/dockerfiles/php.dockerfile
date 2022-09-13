FROM php:7.4-fpm-alpine

WORKDIR /var/www/html

COPY src .

RUN docker-php-ext-install pdo pdo_mysql

# permission denied 된 경우 아래와 같이 특정 폴더에 대해 권한을 변경해야 한다.
RUN chown -R www-data:www-data /var/www/html

# ENTRYPOINT, CMD를 따로 명시하지 않으면 기본 image에 있는 명령들이 수행 됨