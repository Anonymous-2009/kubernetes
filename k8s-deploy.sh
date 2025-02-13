#!/bin/bash

# Set strict mode: exit on error, unset variable, or failed pipeline
set -euo pipefail

# Variables
K8S_DIR="kubernetes"  # Directory where YAML files are stored
NAMESPACE="testing"    # Namespace name

# Function to check if Minikube is installed
check_minikube() {
    if ! command -v minikube &> /dev/null; then
        echo "❌ Minikube is not installed. Please install it first."
        exit 1
    fi
}

# Function to start Minikube if not running
start_minikube() {
    if ! minikube status | grep -q "Running"; then
        echo "🚀 Starting Minikube..."
        minikube start --driver=docker || { echo "❌ Failed to start Minikube"; exit 1; }
    else
        echo "✅ Minikube is already running."
    fi
}

# Function to clean up previous deployments
cleanup() {
    echo "🗑️ Cleaning up old deployments..."
    kubectl delete -f $K8S_DIR --ignore-not-found=true || echo "⚠️ Cleanup failed, but continuing..."
    echo "✅ Old deployments removed."
}

# Function to apply Kubernetes manifests
apply_kubernetes() {
    echo "📂 Applying Kubernetes manifests..."

    # Apply namespace first
    kubectl apply -f $K8S_DIR/namespace.yml || { echo "❌ Failed to apply namespace"; exit 1; }

    # Apply backend and frontend resources
    kubectl apply -f $K8S_DIR/backend-dep.yml -f $K8S_DIR/backend-svc.yml || { echo "❌ Failed to apply backend"; exit 1; }
    kubectl apply -f $K8S_DIR/frontend-dep.yml -f $K8S_DIR/frontend-svc.yml || { echo "❌ Failed to apply frontend"; exit 1; }

    echo "✅ Kubernetes resources applied successfully."
}

# Function to enable port forwarding
port_forward() {
    echo "🔄 Setting up port forwarding..."
    
    # Port forward backend (API)
    kubectl port-forward service/testing-server-svc -n $NAMESPACE 3000:3000 &

    # Port forward frontend (UI)
    kubectl port-forward service/testing-client-svc -n $NAMESPACE 4173:4173 &

    echo "🚀 Frontend available at: http://localhost:4173"
    echo "🚀 Backend API available at: http://localhost:3000"
}

# Function to deploy everything
deploy() {
    check_minikube
    start_minikube
    cleanup
    apply_kubernetes
    sleep 5  # Wait for services to be ready
    port_forward
}

# Run deployment
deploy

