ARG DEBIAN_VERSION=10-slim
FROM debian:${DEBIAN_VERSION} AS builder

ARG HUGO_VERSION=0.110.0
ARG HUGO_FILENAME=hugo_extended_${HUGO_VERSION}_linux-amd64.deb
ARG NODE_VERSION=v18.13.0

RUN apt-get update && apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    git \
    --no-install-recommends

RUN curl -L -o /tmp/node.tar.xz "https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.xz" \
    && mkdir -p /usr/local/lib/nodejs \
    && tar -xJf /tmp/node.tar.xz -C /usr/local/lib/nodejs \
    && rm -f /tmp/node.tar.xz \
    && ln -s /usr/local/lib/nodejs/node-${NODE_VERSION}-linux-x64/bin/node /usr/bin/node \
    && ln -s /usr/local/lib/nodejs/node-${NODE_VERSION}-linux-x64/bin/npm /usr/bin/npm \
    && ln -s /usr/local/lib/nodejs/node-${NODE_VERSION}-linux-x64/bin/npx /usr/bin/npx \
    && npm install -g yarn@1.22.19 \
    && ln -s /usr/local/lib/nodejs/node-${NODE_VERSION}-linux-x64/bin/yarn /usr/bin/yarn

RUN curl -L --retry 3 -o /tmp/hugo.deb "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_FILENAME}" \
    && dpkg -i /tmp/hugo.deb \
    && rm -f /tmp/hugo.deb


