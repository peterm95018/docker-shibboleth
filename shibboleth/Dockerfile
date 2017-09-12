FROM debian:stretch
MAINTAINER Erwan Conjecto (erwan@conjecto.com)

# Install apache2 and shibboleth
RUN apt-get update \
	&& apt-get -y install apache2 libapache2-mod-shib2 \
	&& apt-get clean

COPY httpd-foreground /usr/local/bin/
CMD ["httpd-foreground"]

COPY /apache2/apache2.conf /etc/apache2/
COPY /apache2/sygefor.conf /etc/apache2/
COPY /apache2/shibboleth.conf /etc/apache2/

COPY /apache2/ssl/ca.pem /etc/apache2/
COPY /apache2/ssl/ca-key.pem /etc/apache2/

# Install PHP5
RUN sed -i 's/stretch/jessie/g' /etc/apt/sources.list && apt-get update

# Install PHP5 into image
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
RUN service apache2 restart

EXPOSE 80
EXPOSE 443
