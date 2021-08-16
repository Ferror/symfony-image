FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    git \
    make \
    pkg-config \
    build-essential \
    autoconf \
    bison \
    re2c \
    libxml2-dev \
    libsqlite3-dev \
    libssl-dev \
    zlib1g-dev \
    g++ \
    gcc \
    curl \
    nginx

RUN git clone https://github.com/php/php-src.git
RUN mv php-src/* .
RUN ./buildconf
RUN ./configure \
    --prefix=/opt/php/php8 \
    --enable-debug \
    --with-openssl \
    --with-zlib
RUN make
RUN make install
RUN apt clean && apt autoclean
RUN ln -s /opt/php/php8/bin/php /usr/sbin/php

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename composer
RUN mkdir -p /run/php

COPY nginx.conf         /etc/nginx/nginx.conf
COPY supervisor.conf    /etc/supervisor/conf.d/supervisor.conf
COPY www.conf           /etc/php/8.0/fpm/pool.d/www.conf

WORKDIR /app

EXPOSE 80
