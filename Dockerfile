#Dockerfile Example on running PHP Laravel app using Apache web server 

FROM php:8.1-cli

# Install necessary libraries
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libzip-dev

# Install PHP extensions
RUN docker-php-ext-install \
    mbstring \
    zip \
    git \
    locales \
    unzip \
    vim \
    curl \
    git 

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbsbstring exif pcntl bcmath gd zip

# Copy Laravel application
COPY . /var/www/html

# Set working directory
WORKDIR /var/www/html

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install dependencies
RUN composer install

# Change ownership of our applications
RUN chown -R www-data:www-data /var/www/html

RUN docker-php-ext-install mbstring

COPY .env.example .env
RUN php artisan key:generate

# Expose port 80
EXPOSE 80

# Adjusting Apache configurations
RUN a2enmod rewrite
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Start Laravel Server
CMD php artisan serve --host=0.0.0.0 --port=8000