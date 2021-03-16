FROM debian:jessie
MAINTAINER Erwan Conjecto (erwan@conjecto.com)

######################################
### Install APACHE2 AND SHIBBOLETH ###
######################################

RUN apt-get update && apt-get upgrade -y \
	&& apt-get -y install apache2 libapache2-mod-shib2 \
	&& apt-get clean \
    && a2enmod ssl proxy rewrite proxy_http proxy_fcgi

# Automatically update date for shibboleth
RUN apt-get install -y ntp ntpdate && \
    sed -i 's/debian.pool.ntp.org/fr.pool.ntp.org/g' /etc/ntp.conf && \
#    ntpdate -s fr.pool.ntp.org && \
    update-rc.d ntp enable && \
    /etc/init.d/ntp start
# dpkg-reconfigure tzdata -> Europe -> Paris

####################
### Install PHP5 ###
####################

RUN apt-get update && \
    apt-get install -y \
        php5-common \
        php5-cli \
        php5-curl \
        php5-intl \
        php5-mysql \
		php5-dev \
        php-apc \
        libapache2-mod-php5 \
    && php5enmod curl \
    && apt-get clean

COPY --from=composer:1.7 /usr/bin/composer /usr/bin/composer

##########################
### Install Javascript ###
##########################

RUN curl -fsSL https://deb.nodesource.com/setup_15.x | bash -
RUN apt-get install -y nodejs
RUN apt-get install -y git
RUN apt-get clean
RUN npm install -g n
RUN n 6.8.0
RUN npm install gulp -g
RUN npm install yarn -g
RUN npm install bower -g

##########################
### PUBLIPOSTAGE UTILS ###
##########################

# Install unoconv 0.7
RUN apt-get install -y --no-install-recommends unoconv

# Install libreoffice
RUN apt-get install -y --no-install-recommends \
    libreoffice \
    libreoffice-writer

# Install locales
RUN apt-get install -y locales
# dpkg-reconfigure locales -> fr_FR.UTF-8

RUN apt-get clean

RUN chown www-data. /var/www
RUN chown www-data. /var/www/html -R

######################
### Install XDEBUG ###
######################

RUN apt-get update \
    && apt-get install -y \
        gcc \
        make \
        autoconf \
        libc-dev \
        pkg-config
RUN rm /etc/alternatives/php \
    && ln -s /usr/bin/php5 /etc/alternatives/php
RUN rm /etc/alternatives/phpize \
    && ln -s /usr/bin/phpize5 /etc/alternatives/phpize
RUN pecl install xdebug-2.5.5
COPY xdebug.ini /etc/php5/mods-available/
# RUN echo "zend_extension=$(find /usr/lib/php5/ -name xdebug.so)" >> /etc/php5/mods-available/xdebug.ini
COPY xdebug.ini /etc/php5/apache2/conf.d/
COPY xdebug.ini /etc/php5/cli/conf.d/
RUN echo "zend_extension=$(find /usr/lib/php5/ -name xdebug.so)" >> /etc/php5/apache2/conf.d/xdebug.ini \
    && echo "zend_extension=$(find /usr/lib/php5/ -name xdebug.so)" >> /etc/php5/cli/conf.d/xdebug.ini	

###################
### START SHIBD ###
###################

COPY httpd-foreground /usr/local/bin/
CMD ["httpd-foreground"]

RUN echo "Listen 80" > /etc/apache2/ports.conf

#RUN sed -i 's/stretch/jessie/g' /etc/apt/sources.list && \
#    apt-get update && \
#	apt-get install php5-fpm -y && \
#	sed -i 's/jessie/stretch/g' /etc/apt/sources.list \
#    && apt-get update
#RUN apt-get install nginx -y && apt-get clean

WORKDIR /var/www
EXPOSE 80 82 443
