#!/bin/bash

set -e

echo "Building Docker images..."

# Build recipes-db image
echo "Building recipes-db image..."
cd recipes-db
sudo docker build -t recipes-db:latest .
cd ..

# Build recipes-webapp image
echo "Building recipes-webapp image..."
cd recipes-webapp
sudo docker build -t recipes-webapp:latest .
cd ..

echo "Images built successfully!"

echo "Deploying to k3s..."

# Apply Kubernetes manifests
kubectl apply -f k8s/recipes-db-deployment.yaml
kubectl apply -f k8s/recipes-webapp-deployment.yaml

echo "Deployment applied successfully!"

echo "Waiting for pods to be ready..."

# Wait for recipes-db pod to be ready
kubectl wait --for=condition=ready pod -l app=recipes-db --timeout=300s || {
    echo "recipes-db pod failed to become ready"
    kubectl describe pod -l app=recipes-db
    exit 1
}

# Wait for recipes-webapp pod to be ready
kubectl wait --for=condition=ready pod -l app=recipes-webapp --timeout=300s || {
    echo "recipes-webapp pod failed to become ready"
    kubectl describe pod -l app=recipes-webapp
    exit 1
}

echo "All pods are ready!"

echo "Deployment completed successfully!"
echo "You can access the web application at: http://localhost/"