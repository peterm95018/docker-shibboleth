# Dockerfile for a UCSC / CRM specific Apache2 + PHP5 + Shibboleth Docker image.
# You will then build your own container off this modified base image after
# modifying source files for your host environment.

FROM jtgasper3/debian-shibboleth-sp
MAINTAINER Erwan Conjecto (erwan@conjecto.com)

# modify the shibboleth2.xml, attributes.xml and overwrite in image
COPY /shibboleth-sp/ /etc/shibboleth/

# modify and copy your hosts config files and overwrite in image
COPY /apache2/apache2.conf /etc/apache2/
COPY /apache2/sygefor.conf /etc/apache2/

# modify SSL settings in sites-available/default-ssl.conf
COPY /apache2/sites-available/ /etc/apache2/sites-available/
COPY /apache2/sites-enabled/ /etc/apache2/sites-enabled/

COPY /apache2/ssl/ca.pem /etc/apache2/
COPY /apache2/ssl/ca-key.pem /etc/apache2/

# Install PHP5 into image
RUN apt-get update && apt-get install -y \
emacs \
php5-common \
php5-cli \
php5-mysql \
php5-curl \
php-apc \
libapache2-mod-php5

RUN php5enmod curl

# need to run a2enmod ssl to turn on the SSL module
RUN a2enmod ssl
RUN a2enmod proxy
RUN a2enmod rewrite
RUN a2enmod proxy_http
RUN service apache2 restart

RUN php -r "eval('?>'.file_get_contents('https://getcomposer.org/installer'));"
RUN mv composer.phar /usr/local/bin/composer

COPY /bashrc /root/.bashrc

# Exposed ports
EXPOSE 80
EXPOSE 443
