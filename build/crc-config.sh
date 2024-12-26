#!/bin/bash

# Check if CRC bundle is already cached
if [ -d "/home/runner/.crc/cache" ]; then
    echo "Using cached CRC bundle"
else
    echo "CRC bundle not found in cache, performing setup"
    crc setup
fi

# List of configurations that can be set
# Note: These will override the baseline configs set during image build
configurations=(
  "consent-telemetry"
  "cpus"
  "disable-update-check"
  "disk-size"
  "enable-cluster-monitoring"
  "enable-experimental-features"
  "enable-shared-dirs"
  "host-network-access"
  "http-proxy"
  "https-proxy"
  "ingress-http-port"
  "ingress-https-port"
  "kubeadmin-password"
  "memory"
  "nameserver"
  "network-mode"
  "no-proxy"
  "preset"
  "proxy-ca-file"
  "pull-secret-file"
  "skip-check-admin-helper-cached"
  "skip-check-bundle-extracted"
  "skip-check-crc-dnsmasq-file"
  "skip-check-crc-network"
  "skip-check-crc-network-active"
  "skip-check-crc-symlink"
  "skip-check-daemon-systemd-sockets"
  "skip-check-daemon-systemd-unit"
  "skip-check-kvm-enabled"
  "skip-check-libvirt-driver"
  "skip-check-libvirt-group-active"
  "skip-check-libvirt-installed"
  "skip-check-libvirt-running"
  "skip-check-libvirt-version"
  "skip-check-network-manager-config"
  "skip-check-network-manager-installed"
  "skip-check-network-manager-running"
  "skip-check-obsolete-admin-helper"
  "skip-check-ram"
  "skip-check-root-user"
  "skip-check-supported-cpu-arch"
  "skip-check-systemd-networkd-running"
  "skip-check-user-in-libvirt-group"
  "skip-check-virt-enabled"
  "skip-check-vsock"
  "skip-check-wsl2"
)

# Loop through the list of configurations
for config in "${configurations[@]}"
do
  # Get the value of the environment variable with the same key as the config variable
  env_var=$(env | tr '[:upper:]' '[:lower:]' | tr '_' '-' | grep "$config")
  value="${env_var#*=}"

  # Check if the environment variable is set
  if [[ -n "$value" && "$env_var" =~ $config= ]]
  then
    # Set the configuration using crc
    crc config set "$config" "$value"
    echo "Configured $config=$value"
  fi
done
