#!/bin/bash
set -e

# Navigate to the webapp directory
cd recipes-webapp

# Build the test image
echo "Building test image..."
docker build -t recipes-webapp-test -f Dockerfile.test .

# Run the tests
echo "Running tests..."
docker run --rm recipes-webapp-test

# Clean up
echo "Tests completed."
