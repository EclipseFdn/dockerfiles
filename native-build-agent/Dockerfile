#*******************************************************************************
# Copyright (c) 2024 Eclipse Foundation and others.
# This program and the accompanying materials are made available
# under the terms of the Eclipse Public License 2.0
# which is available at http://www.eclipse.org/legal/epl-v20.html
# SPDX-License-Identifier: EPL-2.0
#*******************************************************************************

##
# Installs required build tools that will be used in the compilation process
# of fullstack development environments. This includes set and tested minimum
# versions of node.js, Hugo, and is based on a GraalVM Mandrel image for native
# compilation for Quarkus.
##

ARG MANDREL_VERSION=23.0
FROM registry.access.redhat.com/quarkus/mandrel-23-rhel8:${MANDREL_VERSION}

ARG NODE_VERSION=v18.20.2
ARG NPM_VERSION=9.6.6
ARG YARN_VERSION=1.22.19
ARG MVN_VERSION=3.9.6

USER root

## Required as RHEL UBI doesn't come with xz-utils or make ootb
RUN dnf install -y xz make

## Add node/yarn as it's used as part of the Java build process to build JSON schemas from API specs
RUN curl -L -o /tmp/node.tar.xz "https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.xz" \
    && mkdir -p /usr/local/lib/nodejs \
    && tar -xJf /tmp/node.tar.xz -C /usr/local/lib/nodejs \
    && rm -f /tmp/node.tar.xz \
    && ln -s /usr/local/lib/nodejs/node-${NODE_VERSION}-linux-x64/bin/node /usr/bin/node \
    && ln -s /usr/local/lib/nodejs/node-${NODE_VERSION}-linux-x64/bin/npm /usr/bin/npm \
    && ln -s /usr/local/lib/nodejs/node-${NODE_VERSION}-linux-x64/bin/npx /usr/bin/npx \
    && npm install -g yarn@${YARN_VERSION} \
    && ln -s /usr/local/lib/nodejs/node-${NODE_VERSION}-linux-x64/bin/yarn /usr/bin/yarn
    
## Add maven, as RHEL version is too old to use quarkus extensions (need 3.6+, RHEL provides 3.5.4)
RUN curl -L -o /tmp/maven.tar.gz "https://dlcdn.apache.org/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz" \
    && mkdir /usr/local/lib/maven \
    && tar -xvf /tmp/maven.tar.gz -C /usr/local/lib/maven \
    && ln -s /usr/local/lib/maven/apache-maven-${MVN_VERSION}/bin/mvn /usr/bin/mvn

USER 10001:0

