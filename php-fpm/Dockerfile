FROM php:5.6-fpm
MAINTAINER Erwan Conjecto (erwan@conjecto.com)

####################
### Install PHP5 ###
####################

RUN apt-get update && apt-get upgrade -y  \
    && apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libicu-dev \
        libxml2-dev \
        libcurl4-openssl-dev \
        libssl-dev \
    && docker-php-ext-install -j$(nproc) curl iconv intl xml soap mcrypt opcache pdo pdo_mysql mysqli mbstring \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
RUN pecl install apcu-4.0.11

###########################
### Install unoconv 0.7 ###
###########################

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
RUN chown www-data. /var/www
RUN chown www-data. /var/www/html -R


#####################
### Add cron taks ###
#####################

RUN apt-get install cron -y --no-install-recommends
RUN echo '0 2 * * * /var/www/sygefor/shell/cron.sh' >> /etc/crontab

WORKDIR /usr/local/etc
CMD ["php-fpm"]
