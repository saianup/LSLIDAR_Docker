cmake_minimum_required(VERSION 3.8)
project(lslidar_driver)

# ===============================
# Compiler settings
# ===============================
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 14)
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# ===============================
# Dependencies
# ===============================
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)
find_package(sensor_msgs REQUIRED)
find_package(diagnostic_updater REQUIRED)
find_package(lslidar_msgs REQUIRED)
find_package(pluginlib REQUIRED)
find_package(pcl_conversions REQUIRED)

find_package(PCL REQUIRED COMPONENTS common io)
find_package(Boost REQUIRED COMPONENTS thread)
find_package(PkgConfig REQUIRED)
pkg_check_modules(PCAP REQUIRED libpcap)

# ===============================
# Include directories
# ===============================
include_directories(
  include
  ${PCL_INCLUDE_DIRS}
  ${Boost_INCLUDE_DIRS}
  ${PCAP_INCLUDE_DIRS}
)

# ===============================
# Executable
# ===============================
add_executable(lslidar_driver_node
  src/lslidar_driver_node.cc
  src/lslidar_driver.cc
  src/input.cc
  src/lsiosr.cpp
)

ament_target_dependencies(lslidar_driver_node
  rclcpp
  std_msgs
  sensor_msgs
  lslidar_msgs
  diagnostic_updater
  pcl_conversions
)

target_link_libraries(lslidar_driver_node
  ${PCL_LIBRARIES}
  ${Boost_LIBRARIES}
  ${PCAP_LIBRARIES}
)

# ===============================
# Install
# ===============================
install(TARGETS lslidar_driver_node
  DESTINATION lib/${PROJECT_NAME}
)

install(DIRECTORY launch params rviz
  DESTINATION share/${PROJECT_NAME}
)

# ===============================
# Export
# ===============================
ament_export_dependencies(
  rclcpp
  std_msgs
  sensor_msgs
  lslidar_msgs
  pcl_conversions
  pluginlib
)

ament_export_include_directories(include)

ament_package()

