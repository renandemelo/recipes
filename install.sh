#!/bin/bash

set -e

echo "Installing k3s..."

# Install k3s with proper kubeconfig permissions and enable default ingress controller (Traefik)
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode=644

# Wait for k3s to be ready
sleep 10

# Create custom Traefik configuration to use ports 8080/8443 instead of 80/443
sudo mkdir -p /var/lib/rancher/k3s/server/manifests/
sudo sh -c 'cat <<EOF > /var/lib/rancher/k3s/server/manifests/traefik-config.yaml
---
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: traefik
  namespace: kube-system
spec:
  valuesContent: |-
    ports:
      web:
        exposedPort: 8080
      websecure:
        exposedPort: 8443
EOF'

# Create directory for kubeconfig if it doesn't exist
mkdir -p ~/.kube

# Copy the kubeconfig file to the default location (if not already done by k3s)
if [ -f /etc/rancher/k3s/k3s.yaml ]; then
    sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
    sudo chown $(id -u):$(id -g) ~/.kube/config
    chmod 600 ~/.kube/config
fi

echo "k3s installed successfully!"
echo "You can now use kubectl to interact with your cluster."

# Verify installation
kubectl version