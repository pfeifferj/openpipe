FROM ubi9/ubi:latest

ARG VERSION=latest
ENV VERSION=$VERSION

COPY setup.sh .

RUN set -x && \
    sh setup.sh --version $VERSION

RUN useradd -m -s /bin/bash crc-user
RUN groupadd sudo
RUN sudo usermod -aG sudo crc-user
RUN echo "crc-user:mypassword" | chpasswd
RUN echo "crc-user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/crc-user && chmod 440 /etc/sudoers.d/crc-user && chown root:root /etc/sudoers.d/crc-user

USER crc-user
