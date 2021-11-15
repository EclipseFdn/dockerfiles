FROM debian:10-slim AS builder

RUN apt-get update && apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    git \
    --no-install-recommends

RUN curl -L -o /tmp/node.tar.xz "https://nodejs.org/dist/v12.22.1/node-v12.22.1-linux-x64.tar.xz" \
    && mkdir -p /usr/local/lib/nodejs \
    && tar -xJf /tmp/node.tar.xz -C /usr/local/lib/nodejs \
    && rm -f /tmp/node.tar.xz \
    && ln -s /usr/local/lib/nodejs/node-v12.22.1-linux-x64/bin/node /usr/bin/node \
    && ln -s /usr/local/lib/nodejs/node-v12.22.1-linux-x64/bin/npm /usr/bin/npm \
    && ln -s /usr/local/lib/nodejs/node-v12.22.1-linux-x64/bin/npx /usr/bin/npx \
    && npm install -g yarn@1.22.10 \
    && ln -s /usr/local/lib/nodejs/node-v12.22.1-linux-x64/bin/npx /usr/bin/yarn

RUN curl -L -o /tmp/hugo.deb "https://github.com/gohugoio/hugo/releases/download/v0.76.5/hugo_0.76.5_Linux-64bit.deb" \
    && dpkg -i /tmp/hugo.deb \
    && rm -f /tmp/hugo.deb
