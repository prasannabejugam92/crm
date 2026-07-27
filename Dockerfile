# Use an official PHP image as the base image
FROM php:8.3-apache

#Set the working directory inside the container
WORKDIR /var/www/html

#Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    && docker-php-ext-install pdo_mysql zip gd

RUN a2enmod rewrite


# Copy the Laravel project files into the container
COPY . /var/www/html

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage \
    && chmod -R 775 /var/www/html/bootstrap/cache


COPY apache.conf /etc/apache2/sites-available/000-default.conf


# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install project dependencies
RUN composer install --no-interaction


# Expose port 9000 and start PHP-FPM
EXPOSE 80

CMD ["apache2-foreground"]
