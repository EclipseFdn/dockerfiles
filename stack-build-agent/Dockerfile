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
FROM alpine:${ALPINE_VERSION}

ARG NODE_VERSION=18.20.1-r0
ARG NPM_VERSION=9.6.6-r0
ARG HUGO_VERSION=0.110.0
ARG HUGO_FILENAME=hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz
ARG YARN_VERSION=1.22.19-r0
ARG JDK_VERSION=11

RUN apk add --no-cache \
    make \
    "nodejs=${NODE_VERSION}" \
    "npm=${NPM_VERSION}" \
    "yarn=${YARN_VERSION}" \
    openjdk${JDK_VERSION}-jdk \
    maven \
    curl \
    bash \
    libc6-compat \
    libstdc++

ENV JAVA_HOME="/usr/lib/jvm/java-${JDK_VERSION}-openjdk"
ENV PATH=$PATH:/usr/lib/jvm/java-${JDK_VERSION}-openjdk/bin

# Manual Hugo setup required for non-supported versions in newer versions of Alpine
RUN curl -L -o /tmp/hugo.tar.gz "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_FILENAME}" \
    && tar -xf "/tmp/hugo.tar.gz" hugo -C /usr/bin

USER 10001:0

