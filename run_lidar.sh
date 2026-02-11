#!/bin/bash

# Stop and remove any existing container
docker rm -f lslidar_driver 2>/dev/null || true

echo "Starting LiDAR driver..."

# Run the container interactively first to debug
docker run -it \
  --name lslidar_driver \
  --network host \
  --privileged \
  -v /dev:/dev \
  --device=/dev/ttyACM0 \
  lslidar-driver:latest \
  bash
