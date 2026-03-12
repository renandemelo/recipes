#!/bin/bash

echo "Testing uninstall.sh script..."

# Check if uninstall.sh exists
if [ ! -f "./uninstall.sh" ]; then
    echo "ERROR: uninstall.sh not found"
    exit 1
fi

echo "uninstall.sh found. Checking permissions..."
chmod +x ./uninstall.sh

echo "Script is ready for testing. To test it, run:"
echo "./uninstall.sh"
echo ""
echo "Note: This script will remove k3s and related components."
echo "Make sure you have backups if needed."