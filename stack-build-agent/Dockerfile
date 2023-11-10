#*******************************************************************************
# Copyright (c) 2023 Eclipse Foundation and others.
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

ARG ALPINE_VERSION=3.18
FROM eclipsecbi/alpine:${ALPINE_VERSION}

ARG NODE_VERSION=18.18.2-r0
ARG NPM_VERSION=9.6.6-r0
ARG HUGO_VERSION=0.111.3-r5
ARG YARN_VERSION=1.22.19-r0
ARG JDK_VERSION=11

RUN apk add --no-cache \
    make \
    "nodejs=${NODE_VERSION}" \
    "npm=${NPM_VERSION}" \
    "hugo=${HUGO_VERSION}" \
    "yarn=${YARN_VERSION}" \
    openjdk${JDK_VERSION}-jdk \
    maven \
    curl \
    bash

ENV JAVA_HOME="/usr/lib/jvm/java-${JDK_VERSION}-openjdk"
ENV PATH=$PATH:/usr/lib/jvm/java-${JDK_VERSION}-openjdk/bin

USER 10001:0

