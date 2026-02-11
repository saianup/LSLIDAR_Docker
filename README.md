# LSLIDAR_Docker

Dockerized ROS2 Humble workspace for running the LSLiDAR driver.

This container builds the driver inside a ROS2 workspace and runs it with hardware access enabled.


## Build

From the project root:

docker build -t lslidar-driver .


## Run

./run_lidar.sh


## Notes

- Uses host networking for ROS2 DDS communication
- Runs container in privileged mode for device access
- Serial device expected at /dev/ttyACM0
- Workspace path inside container: /ros_ws
