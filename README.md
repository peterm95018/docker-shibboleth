December 6, 2016 

Objective: Create a container off a pre-made shibboleth-sp debian image to facilitate the configuration of Shib on any host that can run Docker.

Using the image https://hub.docker.com/r/jtgasper3/debian-shibboleth-sp/ as our base image, I've created a Dockerfile to build out a modified container that can run a full Shib'd web server. This could include application files or be part of a Docker network that includes an app container + shib container.

Notes
We used my cert and key as the values in the sp-cert and sp-key files. It would not be part of a git repo, so you'll want to make sure your host has a SSL cert or a second cert/key configuration for Shibboleth to use.

For this setup, I registered my dev environment with https://www.testshib.org. 

Installation and Setup
The approach here is to modify the apache2 and shibboleth configuration files for your environment and then allow Docker to build an image that includes your modified files.

The /shibboleth-sp directory is used twice in this Dockerfile. 
- the first use is to overwrite the /etc/shibboleth file in the image
- the second is to create a directory in the web server where we can host images and css for error messages.
You will need to edit the shibboleth2.xml and attributes.xml file to meet your applications needs.

In our /apache2 directory, we need to edit the apache2.conf to include the ServerName directive.

In our /apache2/sites-available/default-ssl.conf file, we'll be configuring all our directories that need to be protected by Shibboleth. 

In the /appfiles directory, we have a simple PHP file that can dump all our variables out upon successful authentication.

When we run the docker build command, Docker will pull a base image jtgasper3/debian-shibboleth-sp from the repository and we will then add and overwrite portions of the Debian filesystem with our source files that have our specific customizations. 

One customization here is the addition of SSL. You'll see that I've copied in a certificate and key for my dev environment as well as a default-ssl.conf file in the sites-available direcotry. You'll also note that I've installed PHP5. That's so we can execute a simple index.php flle that dumps out environment variables after a successful authentication. I also installed vim so I could make any edits. That may be in conflict with an approach in the Docker world. Typically, the images used are very stripped down and don't include any "extras" like vim or php.

Finally, I run some a2enmod commands to turn on modules in Apache2. You'll note that I've got proxy turned on and that would be used if I was going to put a NodeJS app on this host. In Docker speak, I'd actually create a new container with the NodeJS app and add it to the Docker network so that I can encapsulate functions to containers.

Our Dockerfile
# Dockerfile for a UCSC / CRM specific Apache2 + PHP5 + Shibboleth Docker image.
# You will then build your own container off this modified base image after
# modifying source files for your host environment.

FROM jtgasper3/debian-shibboleth-sp
MAINTAINER Peter McMillan (peterm@ucsc.edu)

# modify the shibboleth2.xml, attributes.xml and overwrite in image
COPY /shibboleth-sp/ /etc/shibboleth/

# create a directory in webserver to hold Shibboleth logo and css
ADD /shibboleth-sp/logo.png /var/www/html/shibboleth-sp/

# copy your app files (index.php) to the root of the web server
COPY /appfiles/ /var/www/html/appfiles/

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


Typical Docker Commands
docker build -t ssl-shib . <-- note that you work from the build directory. This builds your container
docker run -d ssl-shib -p 80:80 -p 443:443 <-- run your container and map host 80 and 443 to container 80, 443.
docker exec -ti <container id> /bin/bash <-- gives you a shell into the container

A Working Container
Launch a browser and head to https://peterm.ucsc.edu/appfiles/index.php. Login with the provided credentials.


Dump $_SERVER
Hello world ! You are authenticated.
Logout
Your eduPersonPrincipalName (eppn) is : alterego@testshib.org who has an affiliation of Member
You may also be known as Alter Ego
Dump $_SERVER 

Array
(
    [Shib-Application-ID] => default
    [Shib-Session-ID] => _92ef80c2dba3e866d41e281c7ba1e0f3
    [Shib-Identity-Provider] => https://idp.testshib.org/idp/shibboleth
    [Shib-Authentication-Instant] => 2016-12-07T16:28:22.390Z
    [Shib-Authentication-Method] => urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport
    [Shib-AuthnContext-Class] => urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport
    [Shib-Session-Index] => _31c894d525e67b25e41a5c450790cb96
    [affiliation] => Member@testshib.org
    [entitlement] => urn:mace:dir:entitlement:common-lib-terms
    [eppn] => alterego@testshib.org
    [givenName] => Alter
    [persistent-id] => https://idp.testshib.org/idp/shibboleth!https://peterm.ucsc.edu/shibboleth!vHH8PFpA+EFa/7Suj73mBF0lQpI=
    [surname] => Ego
    [unscoped-affiliation] => Member
    [HTTPS] => on
    [SSL_TLS_SNI] => peterm.ucsc.edu
    [SSL_SERVER_S_DN_C] => US
[snipped]

