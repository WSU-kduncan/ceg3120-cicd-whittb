#!/bin/bash
set -e

# Configuration - update these values with your details
CONTAINER_NAME="my_app_container"
IMAGE_NAME="bwhittaker34/whittaker-ceg3120:latest"
PORT_MAPPING="80:80"

echo "Checking for an existing container named '$CONTAINER_NAME'..."
EXISTING=$(docker ps -q -f name="$CONTAINER_NAME")
if [ -n "$EXISTING" ]; then
  echo "Stopping and removing the existing container..."
  docker stop "$CONTAINER_NAME"
  docker rm "$CONTAINER_NAME"
fi

echo "Pulling the latest image: $IMAGE_NAME..."
docker pull "$IMAGE_NAME"

echo "Starting a new container from $IMAGE_NAME on ports $PORT_MAPPING..."
docker run -d --name "$CONTAINER_NAME" -p $PORT_MAPPING "$IMAGE_NAME"

echo "Deployment complete."
