# Use Ubuntu base
FROM ubuntu:jammy

# Set non-interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

# Change to Chinese mirror for better connectivity in Asia
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://mirrors.aliyun.com/ubuntu/|g' /etc/apt/sources.list && \
    sed -i 's|http://ports.ubuntu.com/ubuntu-ports|http://mirrors.aliyun.com/ubuntu-ports|g' /etc/apt/sources.list

# Install basic tools
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Add ROS 2 repository with Chinese mirror
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://mirrors.tuna.tsinghua.edu.cn/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install ROS and dependencies
RUN apt-get update && apt-get install -y \
    ros-humble-desktop-full \
    ros-humble-diagnostic-updater \
    ros-humble-diagnostic-msgs \
    ros-humble-diagnostic-aggregator \
    python3-colcon-common-extensions \
    build-essential \
    cmake \
    git \
    libboost-all-dev \
    libeigen3-dev \
    libpcap-dev \
    ros-humble-pcl-conversions \
    ros-humble-pcl-ros \
    ros-humble-tf2-ros \
    ros-humble-tf2 \
    ros-humble-tf2-geometry-msgs \
    && rm -rf /var/lib/apt/lists/*

# Set up workspace
WORKDIR /ros_ws

# Source ROS
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

# Copy LiDAR driver
COPY lslidar_driver /ros_ws/src/lslidar_driver
COPY params /ros_ws/src/lslidar_driver/lslidar_driver/params/

# Build
RUN . /opt/ros/humble/setup.sh && \
    cd /ros_ws && \
    colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release

# Entrypoint
RUN echo '#!/bin/bash\n\
source /opt/ros/humble/setup.bash\n\
source /ros_ws/install/setup.bash\n\
exec "$@"' > /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
