#!/bin/bash

set -e  # Exit on any error

# ---- 1. Create directory structure ----
echo "Creating project structure..."
mkdir -p docker data
touch Dockerfile docker/install_packages.R docker-compose.yml

# ---- 2. Build Docker image ----
IMAGE_NAME="nist/dimspec:latest"
echo "Building Docker image: $IMAGE_NAME"
docker build -t $IMAGE_NAME .

# ---- 3. Run Docker container ----
CONTAINER_NAME="dimspec"

# Stop and remove any existing container with same name
if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
    echo "Removing existing container: $CONTAINER_NAME"
    docker stop $CONTAINER_NAME || true
    docker rm $CONTAINER_NAME || true
fi

# Run new container
echo "Running container: $CONTAINER_NAME"
docker run -d --name $CONTAINER_NAME \
  -p 3838:3838 -p 8000:8000 \
  -v "$(pwd)/data:/opt/DIMSpec/db" \
  $IMAGE_NAME

echo "✅ DIMSpec container is up and running."
echo "   Shiny apps  → http://localhost:3838"
echo "   Plumber API → http://localhost:8000/__docs__"
