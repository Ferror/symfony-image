FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php

RUN apt-get update && apt-get install -y \
    curl \
    make \
    nginx \
    unzip \
    supervisor\
    php-common \
    php-fpm \
    php8.0-cli \
    php8.0-bz2 \
    php8.0-curl \
    php8.0-intl \
    php8.0-gd \
    php8.0-mbstring \
    php8.0-mysql \
    php8.0-pgsql \
    php8.0-opcache \
    php8.0-soap \
    php8.0-xml \
    php8.0-zip \
    php8.0-apcu \
    php8.0-redis \
    php8.0-xdebug \
    php8.0-yaml \
    php8.0-sqlite

RUN apt-get clean && apt-get autoclean

RUN ln -s /usr/sbin/php-fpm8.0 /usr/sbin/php-fpm

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename composer

RUN mkdir -p /run/php

COPY nginx.conf         /etc/nginx/nginx.conf
COPY supervisor.conf    /etc/supervisor/conf.d/supervisor.conf
COPY www.conf           /etc/php/8.0/fpm/pool.d/www.conf

WORKDIR /app

EXPOSE 80
