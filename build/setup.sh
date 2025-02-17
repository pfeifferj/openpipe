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

# map crc release to openshift version 
## from: https://github.com/crc-org/crc/releases
declare -A VERSION_MAP=(["4.14.12"]="v2.33.0" ["4.17.7"]="v2.45.0" ["4.17.1"]="v2.43.0" ["4.17.0"]="v2.42.0" ["4.17.3"]="v2.44.0" ["4.16.0"]="v2.39.0" ["4.16.4"]="v2.40.0" ["4.16.7"]="v2.41.0" ["4.12.13"]="v2.19.0" ["4.13.12"]="v2.27.0" ["4.13.14"]="v2.28.0" ["4.12.9"]="v2.17.0" ["4.14.8"]="v2.32.0" ["4.14.3"]="v2.30.0" ["4.14.1"]="v2.29.0" ["4.14.7"]="v2.31.0" ["4.13.0"]="v2.20.0" ["4.13.3"]="v2.23.0" ["4.13.6"]="v2.25.0" ["4.13.9"]="v2.26.0" ["4.15.12"]="v2.36.0" ["4.15.10"]="v2.35.0" ["4.15.3"]="v2.34.1" ["4.15.17"]="v2.38.0" ["4.15.14"]="v2.37.1" ["4.17.14"]="v2.47.0" ["4.17.10"]="v2.46.0" )

# look up the CRC release version
if [ "$VERSION" = "latest" ]; then
    # Use the latest stable CRC version for 'latest' tag
    CRC_VERSION="v2.45.0"
else
    CRC_VERSION=${VERSION_MAP[$VERSION]}
fi

# Verify we have a valid CRC version
if [ -z "$CRC_VERSION" ]; then
    echo "Error: No CRC version mapping found for OpenShift version $VERSION"
    exit 1
fi

# Check if pull secret is provided and valid JSON
if [ -z "$PULL_SECRET" ]; then
    echo "Error: PULL_SECRET environment variable is required"
    exit 1
fi

# Verify pull secret is valid JSON with expected structure
if ! echo "$PULL_SECRET" | jq -e '.auths' > /dev/null 2>&1; then
    echo "Error: PULL_SECRET is not valid JSON or missing 'auths' object"
    echo "Pull secret content:"
    echo "$PULL_SECRET"
    exit 1
fi

# Create temporary pull secret file
echo "$PULL_SECRET" > pull-secret.txt

# Show available registries
echo "Available registries in pull secret:"
echo "$PULL_SECRET" | jq -r '.auths | keys[]'

# download release & check if the download was successful
echo "Downloading CRC version ${CRC_VERSION}..."
# Remove 'v' prefix from version for download URL
DOWNLOAD_VERSION=${CRC_VERSION#v}
DOWNLOAD_URL="https://developers.redhat.com/content-gateway/rest/mirror/pub/openshift-v4/clients/crc/${DOWNLOAD_VERSION}"
echo "Download URL: ${DOWNLOAD_URL}"

# Set download file URL
DOWNLOAD_FILE="${DOWNLOAD_URL}/crc-linux-amd64.tar.xz"
echo "Download file: ${DOWNLOAD_FILE}"

# Verify URL is accessible
echo "Verifying URL accessibility..."
HTTP_CODE=$(curl -L -s -o /dev/null -w "%{http_code}" --head "${DOWNLOAD_FILE}")
if [ "$HTTP_CODE" != "200" ]; then
    echo "Error: URL is not accessible (HTTP ${HTTP_CODE})"
    case $HTTP_CODE in
        404)
            echo "File not found. Available versions can be found at:"
            echo "https://developers.redhat.com/content-gateway/rest/mirror/pub/openshift-v4/clients/crc/"
            ;;
        *)
            echo "Unexpected error. Please try again or check your network connection."
            ;;
    esac
    exit 1
fi
echo "URL verified successfully (HTTP 200)"

# Download the file
echo "Starting download..."

if curl -L --fail --progress-bar -o crc-linux-amd64.tar.xz "${DOWNLOAD_FILE}" && \
   [ -f crc-linux-amd64.tar.xz ] && \
   file crc-linux-amd64.tar.xz | grep -q "XZ compressed data" && \
   [ "$(stat -f%z crc-linux-amd64.tar.xz 2>/dev/null || stat -c%s crc-linux-amd64.tar.xz)" -gt 1000000 ]; then
    echo "Download complete and verified."
    
    # extract binary 
    xz -d crc-linux-amd64.tar.xz && \
    tar -xvf crc-linux-amd64.tar
    
    mkdir -p /usr/local/bin
    cp crc-linux-*-amd64/crc /usr/local/bin/
    chmod +x /usr/local/bin/crc
    
    # Update PATH for current session and future sessions
    export PATH="/usr/local/bin:$PATH"
    echo "export PATH=\"/usr/local/bin:\$PATH\"" >> /etc/profile.d/crc.sh
    
    # Cleanup
    rm -rf crc-linux-*-amd64
    rm crc-linux-amd64.tar.xz
    rm pull-secret.txt
else
    STATUS=$?
    echo "Download failed with status: $STATUS"
    echo "Download URL: ${DOWNLOAD_URL}"
    if [ $STATUS -eq 22 ]; then
        echo "HTTP error (404 Not Found). Please verify the version number and URL."
    elif [ $STATUS -eq 60 ]; then
        echo "SSL certificate problem. This might be a proxy or firewall issue."
    elif [ $STATUS -eq 6 ]; then
        echo "Could not resolve host. Please check your internet connection."
    fi
    echo "Attempting HEAD request to verify URL..."
    curl -I "${DOWNLOAD_URL}"
    echo "Current directory contents:"
    ls -la
    exit 1
fi
