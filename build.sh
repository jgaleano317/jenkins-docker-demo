#!/bin/bash

set -e

IMAGE_NAME="jenkins-docker-demo"
CONTAINER_NAME="jenkins-docker-container"

echo "Building Docker image..."

docker build -t $IMAGE_NAME .

echo "Stopping old container if it exists..."

docker rm -f $CONTAINER_NAME 2>/dev/null || true

echo "Starting new container..."

docker run -d \
    --name $CONTAINER_NAME \
    -p 8080:80 \
    $IMAGE_NAME

echo "Container is running!"

docker ps

echo "Checking application health..."

sleep 2

if docker exec "$CONTAINER_NAME" wget -qO- http://localhost >/dev/null; then
    echo "Application health check PASSED!"
else
    echo "Application health check FAILED!"
    exit 1
fi
