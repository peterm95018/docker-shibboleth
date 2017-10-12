FROM debian:stretch
MAINTAINER Erwan Conjecto (erwan@conjecto.com)

# Install apache2 and shibboleth
RUN apt-get update \
	&& apt-get -y install apache2 libapache2-mod-shib2 \
	&& apt-get clean \
    && a2enmod ssl proxy rewrite proxy_http proxy_fcgi

# Start shibd
COPY httpd-foreground /usr/local/bin/
CMD ["httpd-foreground"]

RUN sed -i 's/80/82/g' /etc/apache2/ports.conf
RUN service apache2 restart

WORKDIR /etc/apache2
EXPOSE 82
