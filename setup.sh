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
if [ -z "$VERSION" ]
then
    echo "Version number not specified."
    exit 1
fi

dnf -y install NetworkManager

# map crc release to openshift version
declare -A VERSION_MAP=(
  ["4.7"]="1.24.0"
  ["4.6"]="1.23.0"
  ["4.5"]="1.21.0"
  ["4.4"]="1.19.0"
)

# look up the CRC release version
CRC_VERSION=${VERSION_MAP[$VERSION]}

# download release
curl -L -O "https://developers.redhat.com/content-gateway/rest/mirror/pub/openshift-v4/clients/crc/${CRC_VERSION}/crc-linux-amd64.tar.xz"

# Check if the download was successful
if [ $? -eq 0 ]
then
    echo "Download complete."
else
    echo "Download failed."
fi

# extract binary 
tar xvf crc-linux-amd64.tar.xz
mkdir -p ~/bin
cp crc-linux-*-amd64/crc ~/bin
export PATH=$PATH:$HOME/bin
