FROM ubi8

RUN set -x \
    sh setup.sh --version $VERSION
     
    