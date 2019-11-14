FROM alpine:3.10 as downloader

ARG K8S_VERSION=v1.14.9

RUN apk add --no-cache \
  curl

RUN curl -sSLO https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION}/bin/linux/amd64/kubectl \
  && chmod ug+x kubectl

FROM alpine:3.10

RUN apk add --no-cache \
  bash \
  jq

COPY uid_entrypoint /usr/local/bin
RUN chgrp 0 /etc/passwd && chmod g=rw /etc/passwd \
  && chgrp 0 /usr/local/bin/uid_entrypoint && chmod ug=rx /usr/local/bin/uid_entrypoint \
  && mkdir -p /home/default && chmod ug=rwx /home/default

ENV HOME=/home/default
WORKDIR ${HOME}

COPY --from=downloader kubectl /usr/local/bin/kubectl
COPY k8s /usr/local/bin

ENTRYPOINT [ "uid_entrypoint" ]