FROM phusion/baseimage

EXPOSE 80

CMD /site/docker/bootstrap.sh

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/site/vendor/bin:/site/node_modules/.bin:/site
ENV APP_ENV production

RUN locale-gen --no-purge en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN apt-add-repository -y ppa:ondrej/php \
    && apt-get update \
    && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get install -qqy --force-yes --no-install-recommends \
                    git \
                    php-cli \
                    php-xdebug \
                    php-common \
                    php-fpm \
                    php-zip \
                    php-mbstring \
                    php-mysql \
                    php-xml \
                    ca-certificates \
                    nginx \
                    nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY docker/php.ini /etc/php/7.0/fpm/php.ini
COPY docker/php.ini /etc/php/7.0/cli/php.ini
COPY docker/php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf
COPY docker/nginx.conf /etc/nginx/sites-available/default

RUN phpdismod -v 7.0 -s ALL xdebug

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local && mv /usr/local/composer.phar /usr/local/bin/composer

WORKDIR /site

COPY package.json /site/package.json
RUN npm install

COPY composer.json composer.lock /site/
RUN composer install --no-ansi --optimize-autoloader

COPY . /site

RUN artisan optimize
RUN gulp --production