FROM php:8.1.6-fpm-alpine

# Set working directory
WORKDIR /app

# copy composer from external image
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# start container as user root
USER root

# copy repository into image
COPY . /app

# Install dependencies
RUN composer install


COPY .env.example .env
RUN php artisan key:generate

# Expose port 9000  
EXPOSE 9000

# Start Laravel Server
ENTRYPOINT [ "php", "artisan", "serve", "--host=0.0.0.0", "--port=9000"] 