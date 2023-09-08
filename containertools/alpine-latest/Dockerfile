FROM alpine:latest

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
  && curl -sSL https://github.com/moby/buildkit/releases/download/v0.12.2/buildkit-v0.12.2.linux-amd64.tar.gz | tar zxv \
  && mv bin/buildctl /usr/local/bin \
  && curl -sSL https://github.com/google/go-containerregistry/releases/download/v0.16.1/go-containerregistry_Linux_x86_64.tar.gz | tar zxv \
  && mv crane /usr/local/bin