FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php

RUN apt-get update && apt-get install -y \
    curl \
    make \
    unzip \
    supervisor \
    nginx \
    php-common \
    php-fpm \
    php-pear \
    libz-dev \
    libcurl3-openssl-dev \
    protobuf-compiler \
    php8.0-dev \
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
    php8.0-sqlite \
    php8.0-sockets

ENV PROTOBUF_VERSION "3.17.3"
ENV GRPC_VERSION "1.39.0"
RUN pecl channel-update pecl.php.net
RUN pecl install protobuf-${PROTOBUF_VERSION} grpc-${GRPC_VERSION}

RUN apt-get clean && apt-get autoclean

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename composer

COPY nginx.conf         /etc/nginx/nginx.conf
COPY supervisor.conf    /etc/supervisor/conf.d/supervisor.conf
COPY php.ini            /etc/php/8.0/cli/php.ini
COPY php.ini            /etc/php/8.0/fpm/php.ini

COPY --from=spiralscout/roadrunner:2.4.2 /usr/bin/rr /usr/sbin/rr

WORKDIR /app

EXPOSE 80
