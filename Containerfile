FROM alpine:latest
USER root
LABEL maintainer="Josephine Pfeiffer <jpfeiffe@redhat.com>"

ARG VERSION=latest
ENV VERSION=$VERSION
ENV SMDEV_CONTAINER_OFF=1

COPY setup.sh .

RUN apk add --no-cache bash

RUN set -x && \
    /bin/bash setup.sh --version $VERSION
