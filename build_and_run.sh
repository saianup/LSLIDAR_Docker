#!/bin/bash

# Build the Docker image
echo "Building Docker image for Jetson Orin..."
docker build -t lslidar-driver:latest .

# Set X11 permissions (only if you need GUI)
xhost +local:docker 2>/dev/null || true

# Run the container
echo "Starting LiDAR driver container..."
docker run -d \
  --name lslidar_driver \
  --network host \
  --privileged \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=$DISPLAY \
  lslidar-driver:latest

echo "Container started. Check logs with: docker logs lslidar_driver"
echo "To stop: docker rm -f lslidar_driver"
