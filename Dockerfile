FROM wordpress:6.8.3-php8.3-apache

# Ensure Apache runs exactly one MPM, required for mod_php.
RUN set -eux; \
    rm -f /etc/apache2/mods-enabled/mpm_event.load \
          /etc/apache2/mods-enabled/mpm_event.conf \
          /etc/apache2/mods-enabled/mpm_worker.load \
          /etc/apache2/mods-enabled/mpm_worker.conf; \
    a2enmod mpm_prefork; \
    apache2ctl configtest

EXPOSE 80
