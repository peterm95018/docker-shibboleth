FROM debian:stretch
MAINTAINER Erwan Conjecto (erwan@conjecto.com)

#########################
### Program Utilities ###
#########################

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        git \
        wget \
        nano \
        emacs \
        vim \
        apt-transport-https \
        curl \
        gnupg \
        ca-certificates
COPY /bashrc /root/.bashrc

############################
### Install Yarn and NPM ###
############################

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update \
    && apt-get install -y yarn \
    && apt-get clean

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y --no-install-recommends \
    npm \
    && apt-get clean \
    && apt-get autoremove -y
RUN npm install \
    n gulp@3.9.1 bower -g \
    && n 6.8.0

####################
### Install PHP5 ###
####################

RUN sed -i 's/stretch/jessie/g' /etc/apt/sources.list && apt-get update
RUN apt-get update && apt-get install -y \
    php5-common \
    php5-cli \
    php5-curl \
    php-apc \
    && php5enmod curl \
    && apt-get clean
RUN sed -i 's/jessie/stretch/g' /etc/apt/sources.list && apt-get update

########################
### Install composer ###
########################

RUN php -r "eval('?>'.file_get_contents('https://getcomposer.org/installer'));"
RUN mv composer.phar /usr/local/bin/composer

RUN adduser \
   --system \
   --shell /bin/bash \
   --gecos 'User for managing of git version control' \
   --group \
   --disabled-password \
   --home /home/git \
   git

CMD ["sleep", "14400"]
WORKDIR /var/www/sygefor
