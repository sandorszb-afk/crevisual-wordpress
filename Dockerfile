FROM wordpress:6.8.3-php8.3-apache

RUN set -eux; \
    rm -f /etc/apache2/mods-enabled/mpm_event.load \
          /etc/apache2/mods-enabled/mpm_event.conf \
          /etc/apache2/mods-enabled/mpm_worker.load \
          /etc/apache2/mods-enabled/mpm_worker.conf; \
    a2enmod mpm_prefork; \
    apache2ctl configtest

RUN printf '%s\n' \
    '#!/bin/sh' \
    'set -eu' \
    'echo "CREVISUAL DIAGNOSTIC: Apache MPM modules at runtime:"' \
    'ls -l /etc/apache2/mods-enabled/*mpm* || true' \
    'echo "CREVISUAL DIAGNOSTIC: Apache LoadModule directives:"' \
    'grep -R -n -E "LoadModule .*mpm|Include.*mpm" /etc/apache2 2>/dev/null || true' \
    'echo "CREVISUAL DIAGNOSTIC: Apache env variables:"' \
    'env | grep "^APACHE_" || true' \
    'echo "CREVISUAL DIAGNOSTIC: apache2ctl configtest:"' \
    'apache2ctl configtest || true' \
    'exec apache2-foreground' \
    > /usr/local/bin/crevisual-start && chmod +x /usr/local/bin/crevisual-start

EXPOSE 80
CMD ["crevisual-start"]
