FROM alpine as downloader

ARG K8S_VERSION=v1.9.11
ARG JSONNET_VERSION=0.17.0

RUN apk add --no-cache \
  curl

RUN curl -sSLO https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION}/bin/linux/amd64/kubectl \
  && chmod ug+x kubectl

RUN curl -sSLO https://github.com/google/go-jsonnet/releases/download/v${JSONNET_VERSION}/go-jsonnet_${JSONNET_VERSION}_Linux_x86_64.tar.gz \
  && tar zxf go-jsonnet_${JSONNET_VERSION}_Linux_x86_64.tar.gz \
  && chmod ug+x jsonnet*

FROM eclipsecbi/alpine

RUN apk add --no-cache \
  bash \
  jq

ENV HOME=/home/default
WORKDIR ${HOME}

COPY --from=downloader kubectl /usr/local/bin/kubectl
COPY --from=downloader jsonnet /usr/local/bin/jsonnet
COPY k8s /usr/local/bin

ENTRYPOINT [ "uid_entrypoint" ]