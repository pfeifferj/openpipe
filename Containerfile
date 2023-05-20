FROM alpine:latest
USER root
LABEL maintainer="Josephine Pfeiffer <jpfeiffe@redhat.com>"

ARG VERSION=latest
ENV VERSION=$VERSION

COPY setup.sh .

RUN apk add --no-cache bash

RUN set -x && \
    /bin/bash setup.sh --version $VERSION
