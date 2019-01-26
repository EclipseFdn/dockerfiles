#*******************************************************************************
# Copyright (c) 2019 Eclipse Foundation and others.
# This program and the accompanying materials are made available
# under the terms of the Eclipse Public License 2.0
# which is available at http://www.eclipse.org/legal/epl-v20.html
# SPDX-License-Identifier: EPL-2.0
#*******************************************************************************
FROM debian:jessie-slim

LABEL maintainer="Christopher Guindon <chris.guindon@eclipse-foundation.org>"

# Install requirements
RUN apt-get update && apt-get install -y \
  cron \
  git \
  planet-venus \
  vim \
  xsltproc \
  --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

COPY uid_entrypoint /usr/local/bin
COPY update-planet.sh /usr/local/bin
RUN chgrp 0 /etc/passwd && chmod g=rw /etc/passwd && \
  chgrp 0 /usr/local/bin/uid_entrypoint && chmod ug=rx /usr/local/bin/uid_entrypoint && \
  chgrp 0 /usr/local/bin/update-planet.sh && chmod ug=rx /usr/local/bin/update-planet.sh && \
  chmod -R g+w /usr/share/planet-venus/

# we expect a git repo to be cloned in /var/planet/config, and it should have a planet subfolder
# with a planet.ini file that will be used to generate the blog.
VOLUME [ "/var/planet/www", "/var/planet/cache", "/var/planet/config" ]

USER 10001:0

ENTRYPOINT [ "uid_entrypoint" ]
CMD [ "update-planet.sh", "/var/planet/config/planet", "/var/planet/www" ]