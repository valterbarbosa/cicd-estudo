FROM php:8.1.6-fpm-alpine

WORKDIR /app

RUN apk update && apk add \
    build-base \
    git \
    curl \
    zip \
    libzip-dev \
    libpq-dev \
    unzip

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

USER root

COPY . /app



RUN composer install

COPY .env.example .env
RUN php artisan key:generate

EXPOSE 9000

ENTRYPOINT [ "php", "artisan", "serve", "--host=0.0.0.0", "--port=9000"] 