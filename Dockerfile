FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    make \
    nginx \
    supervisor\
    php-common \
    php-fpm \
    php7.4-cli \
    php7.4-bz2 \
    php7.4-curl \
    php7.4-intl \
    php7.4-gd \
    php7.4-json \
    php7.4-mbstring \
    php7.4-mysql \
    php7.4-pgsql \
    php7.4-opcache \
    php7.4-soap \
    php7.4-xml \
    php7.4-zip \
    php7.4-apcu \
    php7.4-redis \
    php7.4-xdebug \
    php7.4-yaml

RUN apt-get clean && apt-get autoclean

RUN ln -s /usr/sbin/php-fpm7.4 /usr/sbin/php-fpm

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename composer

COPY nginx.conf         /etc/nginx/nginx.conf
COPY supervisor.conf    /etc/supervisor/conf.d/supervisor.conf
COPY www.conf           /etc/php/7.4/fpm/pool.d/www.conf

WORKDIR /app

EXPOSE 80
