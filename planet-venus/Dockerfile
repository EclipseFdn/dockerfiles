#*******************************************************************************
# Copyright (c) 2019 Eclipse Foundation and others.
# This program and the accompanying materials are made available
# under the terms of the Eclipse Public License 2.0
# which is available at http://www.eclipse.org/legal/epl-v20.html
# SPDX-License-Identifier: EPL-2.0
#*******************************************************************************
ARG DEBIAN_VERSION=11-slim
FROM debian:${DEBIAN_VERSION}

ARG REFRESH_FREQUENCY_SECONDS=1200
ENV REFRESH_FREQUENCY_SECONDS=$REFRESH_FREQUENCY_SECONDS

SHELL ["/bin/bash", "-c"]

# Install requirements
RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    ca-certificates git python-is-python2 python2  xsltproc \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN git clone https://github.com/rubys/venus.git planet-venus \
  && python -m compileall /opt/planet-venus \
  && mkdir -p /usr/share/planet-venus/{theme,filter,tools,cgi-bin} \
  && cp -r /opt/planet-venus/themes/* /usr/share/planet-venus/theme \
  && cp -r /opt/planet-venus/filters/* /usr/share/planet-venus/filter \
  && cp -r /opt/planet-venus/*.py* /usr/share/planet-venus/tools \
  && cp /opt/planet-venus/admin_cb.py* /usr/share/planet-venus/cgi-bin \
  && ln -s /opt/planet-venus/planet.py /usr/local/bin/planet \
  && chmod +x /usr/local/bin/planet

COPY uid_entrypoint update-planet.sh /usr/local/bin/
RUN chgrp 0 /etc/passwd && chmod g=rw /etc/passwd \
  && chgrp 0 /usr/local/bin/uid_entrypoint && chmod ug=rx /usr/local/bin/uid_entrypoint \
  && chgrp 0 /usr/local/bin/update-planet.sh && chmod g=rx /usr/local/bin/update-planet.sh \
  && chgrp -R 0 /usr/share/planet-venus/theme && chmod -R g+w /usr/share/planet-venus/theme

ENTRYPOINT [ "uid_entrypoint" ]
