#!/bin/bash

case "$1" in
    start)
        echo "Starting LiDAR..."
        docker exec lslidar_driver bash -c "ros2 topic pub /lslidar_order std_msgs/msg/Int8 'data: 1'"
        ;;
    stop)
        echo "Stopping LiDAR..."
        docker exec lslidar_driver bash -c "ros2 topic pub /lslidar_order std_msgs/msg/Int8 'data: 0'"
        ;;
    logs)
        docker logs lslidar_driver -f
        ;;
    shell)
        docker exec -it lslidar_driver bash
        ;;
    topics)
        docker exec lslidar_driver bash -c "ros2 topic list"
        ;;
    scan)
        echo "Displaying scan data..."
        docker exec lslidar_driver bash -c "ros2 topic echo /scan --no-arr | head -20"
        ;;
    rviz)
        echo "Starting RVIZ in container..."
        docker exec -it lslidar_driver bash -c "rviz2"
        ;;
    *)
        echo "Usage: $0 {start|stop|logs|shell|topics|scan|rviz}"
        echo "  start   - Start the LiDAR"
        echo "  stop    - Stop the LiDAR"
        echo "  logs    - Show container logs"
        echo "  shell   - Open shell in container"
        echo "  topics  - List ROS2 topics"
        echo "  scan    - Display scan data"
        echo "  rviz    - Open RVIZ"
        exit 1
        ;;
esac
