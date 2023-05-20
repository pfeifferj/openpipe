FROM ubi9/ubi:9.1
USER root
LABEL maintainer="Josephine Pfeiffer <jpfeiffe@redhat.com>"

ARG VERSION=latest
ENV VERSION=$VERSION
ENV SMDEV_CONTAINER_OFF=1

COPY setup.sh .

RUN set -x && \
    sh setup.sh --version $VERSION

RUN useradd -m -s /bin/bash crc-user && \
    groupadd sudo && \
    sudo usermod -aG sudo crc-user

RUN echo "crc-user:mypassword" | chpasswd && \
    echo "crc-user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/crc-user && chmod 440 /etc/sudoers.d/crc-user && \
    chown root:root /etc/sudoers.d/crc-user

USER crc-user
