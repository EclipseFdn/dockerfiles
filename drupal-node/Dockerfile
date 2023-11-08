# Base Image
ARG DRUPAL_VERSION=9.5.10
FROM drupal:${DRUPAL_VERSION}-apache

# Set default build-time variables
ARG NODE_VERSION=v18.17.1
ARG NPM_VERSION=10.2.3

# Install necessary packages and PHP extensions
RUN apt update && apt install -y libldap2-dev git mariadb-client vim rsync \
  && docker-php-ext-install ldap \
  && apt-get -y autoremove \
  && apt-get clean autoclean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Node.js and Yarn
RUN curl -L -o /tmp/node.tar.xz "https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.xz" \
  && mkdir -p /usr/local/lib/nodejs \
  && tar -xJf /tmp/node.tar.xz -C /usr/local/lib/nodejs \
  && rm -f /tmp/node.tar.xz \
  && ln -s /usr/local/lib/nodejs/node-${NODE_VERSION}-linux-x64/bin/node /usr/bin/node \
  && ln -s /usr/local/lib/nodejs/node-${NODE_VERSION}-linux-x64/bin/npm /usr/bin/npm \
  && ln -s /usr/local/lib/nodejs/node-${NODE_VERSION}-linux-x64/bin/npx /usr/bin/npx \
  && npm install -g npm@${NPM_VERSION} \
  && npm install -g yarn \
  && ln -s /usr/local/lib/nodejs/node-${NODE_VERSION}-linux-x64/bin/yarn /usr/bin/yarn

# Configure directories and files
RUN mkdir -p drupaltmp session_info private-files web/sites/default/files \
  && chgrp -R root drupaltmp session_info private-files web/sites/default/files \
  && chmod -R g+rwx private-files drupaltmp \
  && sed -ri -e 's!Listen 80!Listen 8080!g' /etc/apache2/ports.conf \
  && sed -ri -e 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/' /etc/apache2/sites-available/000-default.conf
