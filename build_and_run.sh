#!/bin/bash

set -e  # Exit on any error

# ---- 1. Create directory structure ----
echo "Creating project structure..."
mkdir -p ./data
mkdir -p ./shiny_logs

# ---- 2. Build Docker image ----
IMAGE_NAME="mohrezaeib/dimspec:latest"
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
  -p 3838:3838 \
  -p 7000:7000 \
  -p 7001:7001 \
  -p 7002:7002 \
  -p 8000:8000 \
  -p 8080:8080 \
  -v "$(pwd)/data:/opt/DIMSpec/db" \
  -v "$(pwd)/shiny_logs:/var/log/shinyapps" \
  $IMAGE_NAME
# Automatically detect server's external IP address (first non-loopback)
SERVER_IP=$(hostname -I | awk '{print $1}')
echo ""
echo "✅ DIMSpec container is up and running at: http://$SERVER_IP"
echo ""
echo "🌐 Available Shiny Apps:"
echo "   🟢 msMatch         → http://$SERVER_IP:7000"
echo "   🟢 table_explorer  → http://$SERVER_IP:7001"
echo "   🟢 dimspec-qc      → http://$SERVER_IP:7002"
echo ""
echo "📊 Main Shiny app     → http://$SERVER_IP:3838"
echo "🔧 Plumber API        → http://$SERVER_IP:8000/__docs__"
echo ""
echo "📂 Mounted volume     → ./data → /opt/DIMSpec/db"