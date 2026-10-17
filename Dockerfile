FROM wordpress:6.8.3-php8.3-apache

RUN set -eux; \
    a2dismod mpm_event mpm_worker || true; \
    a2enmod mpm_prefork; \
    apache2ctl configtest

RUN printf '%s\n' \
    '#!/bin/sh' \
    'set -eu' \
    'echo "CREVISUAL: remove conflicting Apache MPM"' \
    'rm -f /etc/apache2/mods-enabled/mpm_event.load /etc/apache2/mods-enabled/mpm_event.conf /etc/apache2/mods-enabled/mpm_worker.load /etc/apache2/mods-enabled/mpm_worker.conf' \
    'apache2ctl configtest' \
    'echo "CREVISUAL: initialize WordPress using official Docker entrypoint"' \
    'exec docker-entrypoint.sh apache2-foreground' \
    > /usr/local/bin/crevisual-start && chmod +x /usr/local/bin/crevisual-start

EXPOSE 80
CMD ["crevisual-start"]
