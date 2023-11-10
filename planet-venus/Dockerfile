#*******************************************************************************
# Copyright (c) 2019 Eclipse Foundation and others.
# This program and the accompanying materials are made available
# under the terms of the Eclipse Public License 2.0
# which is available at http://www.eclipse.org/legal/epl-v20.html
# SPDX-License-Identifier: EPL-2.0
#*******************************************************************************
ARG DEBIAN_VERSION=10-slim
FROM debian:${DEBIAN_VERSION}

ARG REFRESH_FREQUENCY_SECONDS=1200
ENV REFRESH_FREQUENCY_SECONDS $REFRESH_FREQUENCY_SECONDS

# Install requirements
RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    planet-venus \
    xsltproc \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY uid_entrypoint /usr/local/bin
COPY update-planet.sh /usr/local/bin
RUN chgrp 0 /etc/passwd && chmod g=rw /etc/passwd \
  && chgrp 0 /usr/local/bin/uid_entrypoint && chmod ug=rx /usr/local/bin/uid_entrypoint \
  && chgrp 0 /usr/local/bin/update-planet.sh && chmod g=rx /usr/local/bin/update-planet.sh \
  && chgrp -R 0 /usr/share/planet-venus/theme && chmod -R g+w /usr/share/planet-venus/theme

ENTRYPOINT [ "uid_entrypoint" ]
