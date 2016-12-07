# Dockerfile for a UCSC / CRM specific Apache2 + PHP5 + Shibboleth Docker image.
# You will then build your own container off this modified base image after
# modifying source files for your host environment.

FROM jtgasper3/debian-shibboleth-sp
MAINTAINER Peter McMillan (peterm@ucsc.edu)

# modify the shibboleth2.xml, attributes.xml and overwrite in image
COPY /shibboleth-sp/ /etc/shibboleth/

# copy your app files (index.php) to the root of the web server
COPY /appfiles/ /var/www/html/appfiles/

# create a directory in webserver to hold Shibboleth logo and css
RUN mkdir -p /var/www/html/shibboleth-sp
COPY /shibboleth-sp/logo.png /var/www/html/shibboleth-sp/

# modify and copy your hosts config files and overwrite in image
COPY /apache2/apache2.conf /etc/apache2/

# modify SSL settings in sites-available/default-ssl.conf
COPY /apache2/sites-available/ /etc/apache2/sites-available/
COPY /apache2/sites-enabled/ /etc/apache2/sites-enabled/

# copy your server.crt and server.key into the image
COPY peterm_ucsc_edu_cert.cer /usr/local/apache2/conf/
COPY peterm.server.key /usr/local/apache2/conf/

# Install PHP5 into image
RUN apt-get update && apt-get install -y \
php5-common \
php5-cli \
libapache2-mod-php5

# Just in case, install an editor to make your life easier
RUN apt-get install -y vim

# need to run a2enmod ssl to turn on the SSL module
RUN a2enmod ssl
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN service apache2 restart


# Exposed ports
EXPOSE 80
EXPOSE 443
