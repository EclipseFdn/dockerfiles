FROM alpine:latest as tool_downloader

ARG K8S_VERSION=v1.22.11
ARG JSONNET_VERSION=0.18.0
ARG JSONNET_BUNDLER_VERSION=v0.4.0

RUN apk add --no-cache \
  curl

RUN curl -sSLO https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION}/bin/linux/amd64/kubectl \
  && chmod ug+x kubectl

RUN curl -sSLO https://github.com/google/go-jsonnet/releases/download/v${JSONNET_VERSION}/go-jsonnet_${JSONNET_VERSION}_Linux_x86_64.tar.gz \
  && tar zxf go-jsonnet_${JSONNET_VERSION}_Linux_x86_64.tar.gz \
  && chmod ug+x jsonnet*

RUN curl -sSLO https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/${JSONNET_BUNDLER_VERSION}/jb-linux-amd64 \
  && chmod ug+x jb-linux-amd64

FROM alpine:latest

RUN apk add --no-cache \
  bash \
  coreutils \
  git \
  jq \
  yq

ENV HOME=/home/default
WORKDIR ${HOME}

COPY --from=tool_downloader kubectl /usr/local/bin/kubectl
COPY --from=tool_downloader jsonnet /usr/local/bin/jsonnet
COPY --from=tool_downloader jb-linux-amd64 /usr/local/bin/jb
