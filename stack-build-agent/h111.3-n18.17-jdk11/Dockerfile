
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
FROM eclipsecbi/alpine:3.18

RUN apk add --no-cache \
    make \
    "nodejs=18.17.1-r0" \
    "npm=9.6.6-r0" \
    "hugo=0.111.3-r4" \
    "yarn=1.22.19-r0" \
    openjdk11-jdk \
    maven \
    curl \
    bash

ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk"
ENV PATH=$PATH:/usr/lib/jvm/java-11-openjdk/bin

USER 10001:0

