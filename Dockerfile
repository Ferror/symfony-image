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
    php8.1-common \
    php8.1-fpm \
    php8.1-cli \
    php8.1-bz2 \
    php8.1-curl \
    php8.1-intl \
    php8.1-gd \
    php8.1-mbstring \
    php8.1-mysql \
    php8.1-pgsql \
    php8.1-opcache \
    php8.1-soap \
    php8.1-xml \
    php8.1-zip \
    php8.1-apcu \
    php8.1-redis \
    php8.1-xdebug \
    php8.1-yaml \
    php8.1-sqlite

RUN apt-get clean && apt-get autoclean

RUN ln -s /usr/sbin/php-fpm8.1 /usr/sbin/php-fpm

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename composer

RUN mkdir -p /run/php

COPY nginx.conf         /etc/nginx/nginx.conf
COPY supervisor.conf    /etc/supervisor/conf.d/supervisor.conf
COPY www.conf           /etc/php/8.1/fpm/pool.d/www.conf

WORKDIR /app

EXPOSE 80
