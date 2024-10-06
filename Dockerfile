FROM php:8.2-rc-apache AS build
ARG DOCKER_USERID="1000"

ENV USER kevin

# Install required dependencies
RUN apt-get update \
    && apt-get install -y zlib1g-dev libzip-dev libssl-dev libmemcached-dev memcached libmemcached-tools \
    && apt-get install -y default-mysql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install and enable the memcached extension
RUN pecl install memcached \
    && docker-php-ext-enable memcached

# Install required PHP extensions
RUN docker-php-ext-install pdo mysqli pdo_mysql zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Set COMPOSER_ALLOW_SUPERUSER to enable plugins in non-interactive mode
ENV COMPOSER_ALLOW_SUPERUSER=1

# Install dependencies using Composer
RUN composer install

# Set permissions
Run adduser --disabled-password --gecos '' ${USER} \
    && usermod -a -G www-data ${USER} \
    && chown -R ${USER}:www-data /var/www/html/var \
RUN chown -R www-data:www-data /var/www/html/var/log
RUN chmod -R 775 /var/www/html/var/log

# die zu Symfony passende Configuration
COPY docker/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 8000