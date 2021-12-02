#*******************************************************************************
# Copyright (c) 2019 Eclipse Foundation and others.
# This program and the accompanying materials are made available
# under the terms of the Eclipse Public License 2.0
# which is available at http://www.eclipse.org/legal/epl-v20.html
# SPDX-License-Identifier: EPL-2.0
#*******************************************************************************
FROM nginx:stable-alpine

# overwrite default config from parent image
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 8080

# change permissions of several files and folders so that members of the root group (gid=0)
# have write permissions to these resources
RUN chmod g=rwx /var/run /var/log/nginx  && \
  find /etc/nginx -type d -exec chmod g=rwx {} \; && \
  find /etc/nginx -type f -exec chmod g=rw {} \; && \
  chgrp -R 0 /usr/share/nginx/html && chmod -R g=rwxs /usr/share/nginx/html && \
  chgrp -R 0 /var/cache/nginx && chmod -R g=rwxs /var/cache/nginx

# Define arbitrary user id to run this image. Part of the root group as all users on OpenShift
USER 10001:0
