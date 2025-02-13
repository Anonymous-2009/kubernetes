#!/bin/bash


<< comment
This is a shell script for deploy a basic Reactjs and Expressjs Project via Docker
and it's have a check docker func, check and pull image, and stop contianer, and start client and server images
comment

# Define images and containers
CLIENT_IMAGE="anonymous2009/testing-client:v1"
SERVER_IMAGE="anonymous2009/testing-server:v1"
CLIENT_CONTAINER="client-container"
SERVER_CONTAINER="server-container"

# Function to check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "❌ Docker is not installed. Please install Docker first."
        exit 1
    fi
    echo "✅ Docker is installed."
}

# Function to check and pull an image if it's missing
check_and_pull_image() {
    local IMAGE_NAME=$1
    if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
        echo "🔍 Image $IMAGE_NAME not found. Pulling..."
        docker pull $IMAGE_NAME || { echo "❌ Failed to pull $IMAGE_NAME. Exiting..."; exit 1; }
    else
        echo "✅ Image $IMAGE_NAME is already present."
    fi
}

# Function to stop and remove a running container
stop_container() {
    local CONTAINER_NAME=$1
    if docker ps -q --filter "name=$CONTAINER_NAME" | grep -q .; then
        echo "⚠️ Stopping and removing existing container: $CONTAINER_NAME..."
        docker stop $CONTAINER_NAME && docker rm $CONTAINER_NAME
        echo "✅ Stopped and removed $CONTAINER_NAME."
    fi
}

# Function to run the server container
run_server() {
    check_and_pull_image $SERVER_IMAGE
    stop_container $SERVER_CONTAINER
    echo "🚀 Starting server container..."
    docker run -d --rm --name $SERVER_CONTAINER -p 3000:3000 $SERVER_IMAGE || {
        echo "❌ Failed to start server container."
        exit 1
    }
    echo "✅ Server container running on port 3000."
}

# Function to run the client container
run_client() {
    check_and_pull_image $CLIENT_IMAGE
    stop_container $CLIENT_CONTAINER
    echo "🚀 Starting client container..."
    docker run -d --rm --name $CLIENT_CONTAINER -p 4173:4173 $CLIENT_IMAGE || {
        echo "❌ Failed to start client container."
        exit 1
    }
    echo "✅ Client container running on port 4173."
}

# Main function to run everything
run_docker_containers() {
    check_docker
    run_server
    run_client
    echo "🎉 Both containers are running successfully!"
}

# Execute the script
run_docker_containers

