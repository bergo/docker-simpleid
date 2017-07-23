FROM php:7.1-apache

RUN apt-get update && \
    apt-get -y install ssl-cert libgmp-dev  libbz2-dev unzip && \
    apt-get clean all && \
    a2enmod ssl && \
    a2ensite default-ssl && \
    sed -i 's|ErrorLog .*|ErrorLog /proc/self/fd/2|;s|CustomLog .*|CustomLog /proc/self/fd/1 combined|' /etc/apache2/sites-available/000-default.conf && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install bcmath && \
    docker-php-ext-install gmp && \
    docker-php-ext-install bz2 && \
    a2enmod rewrite && \
    curl https://getcomposer.org/composer.phar > /usr/bin/composer && \
    chmod 0755 /usr/bin/composer

COPY composer.json /data/simpleid/www/composer.json

# install simpleid server
RUN mkdir -p /data/logs && \
  curl -L http://downloads.sourceforge.net/simpleid/simpleid-1.0.2.tar.gz | tar -C /data -xzf - && rm -rf /var/www/html/ && ln -s /data/simpleid/www /var/www/html && \
  mv /data/simpleid/www/.htaccess.dist /data/simpleid/www/.htaccess && \
  chown www-data.www-data /data/logs /data/simpleid/store /data/simpleid/cache && \
  cd /data/simpleid/www ; composer update --no-dev && \
  cd /data/simpleid ; openssl genrsa -out private.pem 2048 ; openssl rsa -in private.pem -out public.pem -pubout && \
  ./www/vendor/bin/jwkstool.phar add -c private.json private.pem && \
  ./www/vendor/bin/jwkstool.phar add -c public.json public.pem && \
  rm private.pem ; rm public.pem

EXPOSE 80

# configure simpleid server
COPY config.php /data/simpleid/www/config.php

VOLUME /data/simpleid/identities
