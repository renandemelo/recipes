#!/bin/bash

set -e

echo "Uninstalling k3s..."

# Stop and remove k3s
if command -v k3s-uninstall.sh &> /dev/null; then
    echo "Running k3s uninstall script..."
    sudo k3s-uninstall.sh
else
    echo "k3s-uninstall.sh not found. Attempting manual cleanup..."
    
    # Kill k3s processes if they exist
    sudo pkill -f k3s 2>/dev/null || true
    
    # Remove k3s directories and files
    sudo rm -rf /var/lib/rancher/k3s
    sudo rm -rf ~/.kube
    sudo rm -f /etc/rancher/k3s/k3s.yaml
fi

# Remove Traefik configuration file
sudo rm -f /var/lib/rancher/k3s/server/manifests/traefik-config.yaml

echo "k3s uninstalled successfully!"
echo "Please verify by running: kubectl version"