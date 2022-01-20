#!/bin/bash

# Exit on error
set -e

# Set the current directory to the script directory
cd "$(dirname "$0")"

# Destroy the cluster
k3d cluster delete istio-toy-playing-load-balancing
