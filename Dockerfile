FROM wordpress:6.8.3-php8.3-apache

RUN set -eux; \
    a2dismod mpm_event mpm_worker || true; \
    a2enmod mpm_prefork; \
    apache2ctl configtest

RUN printf '%s\n' \
    '#!/bin/sh' \
    'set -eu' \
    'echo "CREVISUAL: removing conflicting Apache MPM at runtime"' \
    'rm -f /etc/apache2/mods-enabled/mpm_event.load /etc/apache2/mods-enabled/mpm_event.conf /etc/apache2/mods-enabled/mpm_worker.load /etc/apache2/mods-enabled/mpm_worker.conf' \
    'echo "CREVISUAL: active Apache MPM:"' \
    'ls -l /etc/apache2/mods-enabled/*mpm*' \
    'apache2ctl configtest' \
    'exec apache2-foreground' \
    > /usr/local/bin/crevisual-start && chmod +x /usr/local/bin/crevisual-start

EXPOSE 80
CMD ["crevisual-start"]
