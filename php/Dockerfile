FROM php:5.6-fpm
MAINTAINER Erwan Conjecto (erwan@conjecto.com)

# Install PHP5 into image
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libicu-dev \
        libxml2-dev \
        libcurl4-openssl-dev \
        vim \
        wget \
        unzip \
        git \
    && docker-php-ext-install -j$(nproc) curl iconv intl xml soap mcrypt opcache pdo pdo_mysql mysqli mbstring \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

# Install unoconv 0.7
RUN sed -i 's/jessie/stretch/g' /etc/apt/sources.list \
    && apt-get update
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    unoconv \
    libreoffice \
    libreoffice-writer \
    && apt-get clean
RUN sed -i 's/stretch/jessie/g' /etc/apt/sources.list \
    && apt-get update

# Monitoring unoconv
COPY /config/unoconv/noti /usr/local/bin/
COPY /config/unoconv/notify /usr/local/bin/
COPY /config/unoconv/unoconv.service /etc/systemd/system
#RUN systemctl enable unoconv.service
#RUN systemctl start unoconv.service

# Utils
RUN php -r "eval('?>'.file_get_contents('https://getcomposer.org/installer'));"
RUN mv composer.phar /usr/local/bin/composer

WORKDIR /var/www/sygefor

# EXPOSE 9000
