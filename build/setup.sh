#!/bin/bash

# parse command-line arguments
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -v|--version)
        VERSION="$2"
        shift
        shift
        ;;
        *)
        echo "Unknown argument: $1"
        exit 1
        ;;
    esac
done

# check that the version number is set
if [[ -z "$VERSION" ]]
then
    echo "Version number not specified."
    exit 1
fi

dnf -y update && \
dnf -y install  xz \
                sudo \
                git \
                libvirt \
                libvirt-daemon-kvm \
                qemu-kvm

systemctl enable --now libvirtd

# map crc release to openshift version 
## from: https://github.com/crc-org/crc/releases
declare -A VERSION_MAP=(["4.14.12"]="v2.33.0" ["4.16.0"]="v2.39.0" ["4.16.4"]="v2.40.0" ["4.16.7"]="v2.41.0" ["4.11.13"]="v2.11.0" ["4.11.18"]="v2.12.0" ["4.12.13"]="v2.19.0" ["4.13.12"]="v2.27.0" ["4.13.14"]="v2.28.0" ["4.12.5"]="v2.15.0" ["4.12.0"]="v2.13.1" ["4.12.1"]="v2.14.0" ["4.12.9"]="v2.17.0" ["4.14.8"]="v2.32.0" ["4.14.3"]="v2.30.0" ["4.14.1"]="v2.29.0" ["4.14.7"]="v2.31.0" ["4.13.0"]="v2.20.0" ["4.13.3"]="v2.23.0" ["4.13.6"]="v2.25.0" ["4.13.9"]="v2.26.0" ["4.15.12"]="v2.36.0" ["4.15.10"]="v2.35.0" ["4.15.3"]="v2.34.1" ["4.15.17"]="v2.38.0" ["4.15.14"]="v2.37.1" )

# look up the CRC release version
CRC_VERSION=${VERSION_MAP[$VERSION]}

# download release & check if the download was successful
if ! curl -L -O "https://developers.redhat.com/content-gateway/rest/mirror/pub/openshift-v4/clients/crc/${CRC_VERSION}/crc-linux-amd64.tar.xz";
then
    echo "Download complete."
else
    echo "Download failed."
fi

# extract binary 
tar -xvf crc-linux-amd64.tar.xz

mkdir -p /usr/local/bin
cp crc-linux-*-amd64/crc /usr/local/bin/
export PATH=$PATH:/usr/local/bin
echo "export PATH=$PATH:root/bin" >> /root/.bashrc

rm -rf crc-linux-*-amd64
rm crc-linux-amd64.tar.xz
