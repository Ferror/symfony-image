FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y software-properties-common
RUN apt-get install \
    autoconf \
    re2c \
    bison \
    libsqlite3-dev \
    libpq-dev \
    libonig-dev \
    libfcgi-dev \
    libfcgi0ldbl \
    libjpeg-dev \
    libpng-dev \
    libssl-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libxpm-dev \
    libgd-dev \
    libmysqlclient-dev \
    libfreetype6-dev \
    libxslt1-dev \
    libpspell-dev \
    libzip-dev \
    libgccjit-10-dev

RUN git clone https://github.com/php/php-src.git && cd php-src
RUN ./buildconf

RUN ./configure \
    --prefix=/opt/php/php8 \
    --enable-cli \
    --enable-fpm \
    --enable-intl \
    --enable-mbstring \
    --enable-opcache \
    --enable-sockets \
    --enable-soap \
    --with-curl \
    --with-freetype \
    --with-fpm-user=www-data \
    --with-fpm-group=www-data \
    --with-jpeg \
    --with-mysql-sock \
    --with-mysqli \
    --with-openssl \
    --with-pdo-mysql \
    --with-pgsql \
    --with-xsl \
    --with-zlib

RUN make && make test && make install
RUN apt-get clean && apt-get autoclean
RUN ln -s /usr/sbin/php-fpm8 /usr/sbin/php-fpm

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename composer

RUN mkdir -p /run/php

COPY nginx.conf         /etc/nginx/nginx.conf
COPY supervisor.conf    /etc/supervisor/conf.d/supervisor.conf
COPY www.conf           /etc/php/8.0/fpm/pool.d/www.conf

WORKDIR /app

EXPOSE 80
