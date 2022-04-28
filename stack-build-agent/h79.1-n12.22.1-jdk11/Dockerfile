
#*******************************************************************************
# Copyright (c) 2021 Eclipse Foundation and others.
# This program and the accompanying materials are made available
# under the terms of the Eclipse Public License 2.0
# which is available at http://www.eclipse.org/legal/epl-v20.html
# SPDX-License-Identifier: EPL-2.0
#*******************************************************************************

##
# Installs required build tools that will be used in the compilation process
# of fullstack development environments. This includes set and tested minimum
# versions of node.js, Hugo, and Java.
##
FROM eclipsecbi/alpine:3.13

## Pull in previous release packages for older LTS Nodejs
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.12/main' >> /etc/apk/repositories \
    && apk add --no-cache \
    make \
    "nodejs<13.0.0" \
    "npm~=12.22.10-r0" \
    "hugo>0.76.5" \
    openjdk11-jdk \
    maven \
    "yarn=1.22.4-r0" \
    curl \
    bash

ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk"
ENV PATH=$PATH:/usr/lib/jvm/java-11-openjdk/bin

USER 10001:0

