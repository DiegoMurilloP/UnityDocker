#!/bin/bash
set -e

# Source de ROS 2 y del workspace
source /opt/ros/jazzy/setup.bash
source /ros2_ws/install/setup.bash

exec "$@"

