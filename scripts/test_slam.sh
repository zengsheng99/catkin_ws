#!/bin/sh
CATKIN_WS=$(cd "$(dirname "$0")/.." && pwd)
export TURTLEBOT_3D_SENSOR=kinect
export GAZEBO_PLUGIN_PATH=$CATKIN_WS/devel/lib:/opt/ros/noetic/lib

xterm -hold -e "source /opt/ros/noetic/setup.bash; source $CATKIN_WS/devel/setup.bash; export TURTLEBOT_3D_SENSOR=kinect; export GAZEBO_PLUGIN_PATH=$CATKIN_WS/devel/lib:/opt/ros/noetic/lib; roslaunch turtlebot_gazebo turtlebot_world.launch" &
sleep 5
xterm -hold -e "source /opt/ros/noetic/setup.bash; source $CATKIN_WS/devel/setup.bash; export TURTLEBOT_3D_SENSOR=kinect; export GAZEBO_PLUGIN_PATH=$CATKIN_WS/devel/lib:/opt/ros/noetic/lib; roslaunch turtlebot_gazebo gmapping_demo.launch" &
sleep 5
xterm -hold -e "source /opt/ros/noetic/setup.bash; source $CATKIN_WS/devel/setup.bash; export TURTLEBOT_3D_SENSOR=kinect; export GAZEBO_PLUGIN_PATH=$CATKIN_WS/devel/lib:/opt/ros/noetic/lib; roslaunch turtlebot_rviz_launchers view_navigation.launch" &
sleep 5
xterm -hold -e "source /opt/ros/noetic/setup.bash; source $CATKIN_WS/devel/setup.bash; export TURTLEBOT_3D_SENSOR=kinect; export GAZEBO_PLUGIN_PATH=$CATKIN_WS/devel/lib:/opt/ros/noetic/lib; roslaunch turtlebot_teleop keyboard_teleop.launch" &
