#!/bin/bash
set -e

# start udev
/lib/systemd/systemd-udevd --daemon

echo 128 > /sys/module/usbcore/parameters/usbfs_memory_mb

# setup ros2 environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
source "$WORKSPACE_ROOT/install/setup.bash"

exec "$@"
