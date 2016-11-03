#!/bin/bash

# Production vs. Development
if [ "$APP_ENV" != "production" ]; then
    phpenmod -v 7.0 -s ALL xdebug
fi

# PHP FPM Service
mkdir -p /etc/service/php-fpm
cp /site/docker/runit-phpfpm.sh /etc/service/php-fpm/run

# Nginx Service
mkdir -p /etc/service/nginx
cp /site/docker/runit-nginx.sh /etc/service/nginx/run

exec /sbin/my_init