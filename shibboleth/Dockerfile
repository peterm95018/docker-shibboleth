FROM debian:stretch
MAINTAINER Erwan Conjecto (erwan@conjecto.com)

# Install apache2 and shibboleth
RUN apt-get update && apt-get upgrade -y \
	&& apt-get -y install apache2 libapache2-mod-shib2 libapache2-mod-rpaf \
	&& apt-get clean \
    && a2enmod ssl proxy rewrite proxy_http proxy_fcgi rpaf

# Automatically update date
RUN apt-get install -y ntp ntpdate && \
    sed -i 's/debian.pool.ntp.org/fr.pool.ntp.org/g' /etc/ntp.conf && \
#    ntpdate -s fr.pool.ntp.org && \
    update-rc.d ntp enable && \
    /etc/init.d/ntp start
# dpkg-reconfigure tzdata -> Europe -> Paris

# Start shibd
COPY httpd-foreground /usr/local/bin/
CMD ["httpd-foreground"]

RUN sed -i 's/80/82/g' /etc/apache2/ports.conf
RUN service apache2 restart

WORKDIR /etc/apache2
EXPOSE 82
