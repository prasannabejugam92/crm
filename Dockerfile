# Use an official PHP image as the base image
FROM php:8.3-apache

#Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    curl \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    libicu-dev \
    libpq-dev

# Configure GD
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# Install PHP extensions
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    mysqli \
    mbstring \
    zip \
    exif \
    pcntl \
    bcmath \
    gd \
    intl


# Enable Apache rewrite
RUN a2enmod rewrite headers

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
#COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

#Set the working directory inside the container
WORKDIR /var/www/html

# Copy the Laravel project files into the container
COPY . /var/www/html


# Copy application
COPY . .

# Install project dependencies
RUN composer install --no-dev --optimize-autoloader

# Apache VirtualHost
#COPY docker/apache/laravel.conf /etc/apache2/sites-available/000-default.conf
COPY laravel.conf /etc/apache2/sites-available/000-default.conf

# Permissions
RUN chown -R www-data:www-data /var/www/html \
 && chmod -R 775 storage bootstrap/cache

#RUN chown -R www-data:www-data /var/www/html \
#&& chmod -R 775 /var/www/html/storage \
#&& chmod -R 775 /var/www/html/bootstrap/cache


# Expose port 80 and start PHP-FPM
EXPOSE 80

CMD ["apache2-foreground"]