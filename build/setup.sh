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
declare -A VERSION_MAP=(["4.10.14"]="v2.4.1" ["4.10.12"]="v2.3.0" ["4.10.18"]="v2.5.1" ["4.9.18"]="v1.40.0" ["4.11.13"]="v2.11.0" ["4.11.18"]="v2.12.0" ["4.12.13"]="v2.19.0" ["4.13.12"]="v2.27.0" ["4.13.14"]="v2.28.0" ["4.12.5"]="v2.15.0" ["4.12.0"]="v2.13.1" ["4.12.1"]="v2.14.0" ["4.12.9"]="v2.17.0" ["4.11.3"]="v2.9.0" ["4.11.1"]="v2.8.0" ["4.11.0"]="v2.7.1" ["4.11.7"]="v2.10.2" ["4.14.1"]="v2.29.0" ["4.10.3"]="v2.0.1" ["4.10.9"]="v2.2.2" ["4.13.0"]="v2.20.0" ["4.13.3"]="v2.23.0" ["4.13.6"]="v2.25.0" ["4.13.9"]="v2.26.0" ["4.10.22"]="v2.6.0" )

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
