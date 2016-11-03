#!/usr/bin/env bash
exec /usr/sbin/php-fpm7.0 --nodaemonize -R --fpm-config /etc/php/7.0/fpm/php-fpm.conf
