FROM php:8.1-cli

ARG DOCKER_USERID="1000"

# Install necessary packages
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip git openssh-client libz-dev libpng-dev libxml2-dev wget \
    && rm -rf /var/lib/apt/lists/*

# Install Symfony CLI
RUN wget https://get.symfony.com/cli/installer -O - | bash && mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

# Install Composer
COPY --from=composer:2.1 /usr/bin/composer /usr/local/bin/composer

# Install Xdebug and configure if needed
RUN pecl install xdebug && docker-php-ext-enable xdebug \
    && { \
      echo "xdebug.mode=debug"; \
      echo "xdebug.client_host=host.docker.internal"; \
      echo "xdebug.client_port=9003"; \
    } >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Set PHP configuration if needed
RUN echo "memory_limit = 1G" > /usr/local/etc/php/conf.d/memory-limit.ini \
    && echo "max_execution_time = 0" > /usr/local/etc/php/conf.d/max-execution-time.ini

# Copy entrypoint script if needed
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod a+x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

WORKDIR /opt/project
