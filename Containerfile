FROM fedora:latest
USER root
LABEL maintainer="Josephine Pfeiffer <jpfeiffe@redhat.com>"

ARG VERSION=latest
ENV VERSION=$VERSION
ENV SMDEV_CONTAINER_OFF=1

COPY setup.sh .
COPY crc-config.sh .

RUN set -x && \
    sh setup.sh --version $VERSION

CMD ["/sbin/init"]