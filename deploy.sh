#!/bin/bash

set -e

echo "Building Docker images..."
echo "Building recipes-db image..."
cd recipes-db
sudo docker build -t recipes-db:latest .
cd ..

echo "Building recipes-webapp image..."
cd recipes-webapp
sudo docker build -t recipes-webapp:latest .
cd ..

echo "Images built successfully!"

echo "Deploying to k3s..."

# Load images into k3s cluster using ctr (k3s containerd client)
echo "Loading images into k3s cluster..."
# Save the images as tar files and load them into k3s
sudo docker save recipes-db:latest | sudo k3s ctr images import -
sudo docker save recipes-webapp:latest | sudo k3s ctr images import -

# Delete existing pods to force image refresh
echo "Deleting existing pods to force image refresh..."
kubectl delete pod -l app=recipes-db --ignore-not-found
kubectl delete pod -l app=recipes-webapp --ignore-not-found

# Apply Kubernetes manifests (they use imagePullPolicy: IfNotPresent)
kubectl apply -f k8s/recipes-db-deployment.yaml
kubectl apply -f k8s/recipes-webapp-deployment.yaml
kubectl apply -f k8s/recipes-webapp-ingress.yaml

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
echo "You can access the web application at: http://localhost:8080/"