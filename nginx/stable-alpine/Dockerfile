#*******************************************************************************
# Copyright (c) 2019 Eclipse Foundation and others.
# This program and the accompanying materials are made available
# under the terms of the Eclipse Public License 2.0
# which is available at http://www.eclipse.org/legal/epl-v20.html
# SPDX-License-Identifier: EPL-2.0
#*******************************************************************************
FROM nginx:stable-alpine

# overwrite default config from parent image
RUN sed -i 's/listen\( \+\)80/listen\18080/' /etc/nginx/conf.d/default.conf
RUN sed -i 's/^ *user .*;$//' /etc/nginx/nginx.conf
EXPOSE 8080

COPY "uid_entrypoint" /usr/local/bin/

# change permissions of several files and folders so that member of the root group (gid=0)
# have write permissions to these resources
RUN chmod g=rwx /var/run /var/log/nginx  && \
  find /etc/nginx -type d -exec chmod g=rwx {} \; && \
  find /etc/nginx -type f -exec chmod g=rw {} \; && \
  chgrp 0 /usr/share/nginx/html && chmod g=rwxs /usr/share/nginx/html && \
  chgrp 0 /var/cache/nginx && chmod g=rwxs /var/cache/nginx && \
  chgrp 0 /etc/passwd && chmod g=rw /etc/passwd && \
  chgrp 0 /usr/local/bin/uid_entrypoint && chmod ug=rx /usr/local/bin/uid_entrypoint

RUN awk '/server_name/ { print; print "    port_in_redirect off;"; next }1' /etc/nginx/conf.d/default.conf > /tmp/default.conf && \
  mv /tmp/default.conf /etc/nginx/conf.d/default.conf

# Define arbitrary user id to run this image. Part of the root group as all users on OpenShift
USER 10001:0

# Replace the user id of the "nginx" user by the current one @ runtime (as returned by $(id -u)).
# nginx user has been created by the parent image, and we try to reuse it as much as we can.
ENTRYPOINT [ "/usr/local/bin/uid_entrypoint" ]

# Repeting CMD from parent image
CMD [ "nginx", "-g", "daemon off;" ]