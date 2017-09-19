FROM debian:stretch
MAINTAINER Erwan Conjecto (erwan@conjecto.com)

# Install apache2 and shibboleth
RUN apt-get update \
	&& apt-get -y install apache2 libapache2-mod-shib2 \
	&& apt-get clean
COPY httpd-foreground /usr/local/bin/
CMD ["httpd-foreground"]

# Install PHP5
RUN sed -i 's/stretch/jessie/g' /etc/apt/sources.list && apt-get update
RUN apt-get update && apt-get install -y \
    php5-common \
    php5-cli \
    php5-mysql \
    php5-curl \
    php-apc \
    libapache2-mod-php5 \
    && apt-get clean

# Activate some modules
RUN php5enmod curl
RUN a2enmod ssl
RUN a2enmod proxy
RUN a2enmod rewrite
RUN a2enmod proxy_http

RUN sed -i 's/jessie/stretch/g' /etc/apt/sources.list && apt-get update

# listen port 82
RUN sed -i 's/80/82/g' /etc/apache2/ports.conf
RUN service apache2 restart

WORKDIR /etc/apache2

EXPOSE 82
