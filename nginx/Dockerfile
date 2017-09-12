FROM php:5.6-fpm
MAINTAINER Erwan Conjecto (erwan@conjecto.com)

# Install PHP5 into image
RUN apt-get update \
    && apt-get install -y \
    nginx \
    php5-mysql \
    php5-curl \
    php-apc \
    && apt-get clean \
    && php5enmod curl
COPY /config/php.ini /etc/php5/cli/
COPY /config/php.ini /etc/php5/fpm/

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
RUN systemctl enable unoconv.service
# RUN systemctl start unoconv.service

# Copy certificates
RUN mkdir /etc/nginx/certificates
COPY /config/ssl/ca.pem /etc/nginx/certificates
COPY /config/ssl/ca-key.pem /etc/nginx/certificates
RUN service nginx restart

# Utils
RUN php -r "eval('?>'.file_get_contents('https://getcomposer.org/installer'));"
RUN mv composer.phar /usr/local/bin/composer
RUN apt-get install emacs -y --no-install-recommends
COPY /config/bashrc /root/.bashrc
