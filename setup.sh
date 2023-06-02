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
declare -A VERSION_MAP=(
  ["latest"]="2.20.0"
  ["4.13.0"]="2.20.0" # latest
  ["4.12.13"]="2.18.0"
  ["4.12.0"]="2.13.1"
  ["4.11.0"]="2.7.1"
  ["4.10.3"]="2.0.1"
)

# look up the CRC release version
CRC_VERSION=${VERSION_MAP[$VERSION]}

# download release
curl -L -O "https://developers.redhat.com/content-gateway/rest/mirror/pub/openshift-v4/clients/crc/${CRC_VERSION}/crc-linux-amd64.tar.xz"

# Check if the download was successful
if [[ $? -eq 0 ]]
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
echo 'export PATH=$PATH:root/bin' >> /root/.bashrc

rm -rf crc-linux-*-amd64
rm crc-linux-amd64.tar.xz
