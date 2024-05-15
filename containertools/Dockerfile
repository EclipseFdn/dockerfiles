#*******************************************************************************
# Copyright (c) 2023 Eclipse Foundation and others.
# This program and the accompanying materials are made available
# under the terms of the Eclipse Public License 2.0
# which is available at http://www.eclipse.org/legal/epl-v20.html
# SPDX-License-Identifier: EPL-2.0
#*******************************************************************************

ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}

ARG BUILDKIT_VERSION=v0.13.2
ARG GO_CONTAINER_REG_VERSION=v0.19.1
ARG JSONNET_VERSION=0.20.0

RUN apk add --no-cache \
    bash \
    coreutils \
    curl \
    git \
    gnupg \
    jq \
    openssh-client \
    rsync \
    ttf-dejavu \
    unzip \
    wget \
    zip \
  && curl -sSL https://github.com/moby/buildkit/releases/download/${BUILDKIT_VERSION}/buildkit-${BUILDKIT_VERSION}.linux-amd64.tar.gz | tar zxv \
  && mv bin/buildctl /usr/local/bin \
  && curl -sSL https://github.com/google/go-containerregistry/releases/download/${GO_CONTAINER_REG_VERSION}/go-containerregistry_Linux_x86_64.tar.gz | tar zxv \
  && mv crane /usr/local/bin \
  && curl -sSLO https://github.com/google/go-jsonnet/releases/download/v${JSONNET_VERSION}/go-jsonnet_${JSONNET_VERSION}_Linux_x86_64.tar.gz \
  && tar zxf go-jsonnet_${JSONNET_VERSION}_Linux_x86_64.tar.gz \
  && chmod ug+x jsonnet* \
  && mv jsonnet* /usr/local/bin \
  && rm go-jsonnet_${JSONNET_VERSION}_Linux_x86_64.tar.gz
