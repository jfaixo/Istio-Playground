#!/bin/bash

# Exit on error
set -e

# Set the current directory to the script directory
cd "$(dirname "$0")"

# Pre checks
if ! command -v istioctl &> /dev/null
then
    echo "istioctl not installed";
    exit 1;
fi
if ! command -v k3d &> /dev/null
then
    echo "k3d not installed";
    exit 1;
fi
if ! command -v helm &> /dev/null
then
    echo "helm not installed";
    exit 1;
fi

# Create a simple k3s test cluster with
# - 2 kubernetes nodes
# - without the basic traefik instance provided with k3d
# - mapping the local 8080 port to the port 80 of the load balancer
k3d cluster create istio-toy-playing-load-balancing --agents 2 --k3s-server-arg "--no-deploy=traefik" -p 8080:80@loadbalancer

# Install istio
kubectl label ns default istio-injection=enabled
istioctl install -y

# Add Prometheus, Kiali & Grafana
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/prometheus.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/kiali.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/grafana.yaml

# Deploy the various samples
helm install load-balancing ./helm-chart
