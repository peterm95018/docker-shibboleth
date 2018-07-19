FROM debian:stretch
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

RUN sed -i 's/stretch/jessie/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y \
        php5-common \
        php5-cli \
        php5-curl \
        php5-intl \
        php5-mysql \
        php-apc \
        libapache2-mod-php5 \
    && php5enmod curl \
    && apt-get clean
RUN sed -i 's/jessie/stretch/g' /etc/apt/sources.list \
    && apt-get update

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

###################
### START SHIBD ###
###################

COPY httpd-foreground /usr/local/bin/
CMD ["httpd-foreground"]

WORKDIR /etc/apache2
EXPOSE 443
