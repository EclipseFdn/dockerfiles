# Runtime image for deployed Drupal sites. It has no git, Node.js, npm or
# Yarn: sites build in eclipsefdn/drupal-node and copy the result into this
# image (see README.md).

# Base Image
ARG DRUPAL_VERSION=11-php8.5
FROM drupal:${DRUPAL_VERSION}-apache

# Install necessary packages and PHP extensions shared by all Drupal sites.
# gd (with FreeType, JPEG, PNG, WebP and AVIF) already comes with the drupal
# image. APCu settings (such as apc.shm_size) stay in each site's apcu.ini.
RUN apt-get update && apt-get install -y libldap2-dev mariadb-client vim rsync \
  && docker-php-ext-install ldap \
  && pecl install apcu \
  && docker-php-ext-enable apcu \
  && apt-get -y autoremove \
  && apt-get clean autoclean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure directories and files
RUN mkdir -p drupaltmp session_info private-files web/sites/default/files \
  && chgrp -R root drupaltmp session_info private-files web/sites/default/files \
  && chmod -R g+rwx private-files drupaltmp \
  && sed -ri -e 's!Listen 80!Listen 8080!g' /etc/apache2/ports.conf \
  && sed -ri -e 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/' /etc/apache2/sites-available/000-default.conf
