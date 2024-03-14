FROM alpine:latest as tool_downloader

ARG OCP_VERSION=4.13.0
ARG JSONNET_VERSION=0.20.0
ARG JSONNET_BUNDLER_VERSION=v0.5.1

RUN apk add --no-cache \
  curl

RUN curl -sSLO "https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/${OCP_VERSION}/openshift-client-linux.tar.gz" \
  && tar zxf openshift-client-linux.tar.gz \
  && chmod ug+x kubectl \
  && chmod ug+x oc

RUN curl -sSLO https://github.com/google/go-jsonnet/releases/download/v${JSONNET_VERSION}/go-jsonnet_${JSONNET_VERSION}_Linux_x86_64.tar.gz \
  && tar zxf go-jsonnet_${JSONNET_VERSION}_Linux_x86_64.tar.gz \
  && chmod ug+x jsonnet*

RUN curl -sSLO https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/${JSONNET_BUNDLER_VERSION}/jb-linux-amd64 \
  && chmod ug+x jb-linux-amd64

FROM alpine:latest

RUN apk add --no-cache \
  bash \
  coreutils \
  gcompat \
  git \
  jq \
  yq

ENV HOME=/home/default
WORKDIR ${HOME}

COPY --from=tool_downloader kubectl /usr/local/bin/kubectl
COPY --from=tool_downloader oc /usr/local/bin/oc
COPY --from=tool_downloader jsonnet /usr/local/bin/jsonnet
COPY --from=tool_downloader jb-linux-amd64 /usr/local/bin/jb
