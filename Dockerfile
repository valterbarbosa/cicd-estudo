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

CMD php artisan serve --host=0.0.0.0 --port=8000