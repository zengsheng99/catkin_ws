#!/bin/sh
export TURTLEBOT_3D_SENSOR=kinect
export GAZEBO_PLUGIN_PATH=/home/ubuntu/catkin_ws/devel/lib:/opt/ros/noetic/lib
export TURTLEBOT_GAZEBO_WORLD_FILE=/home/ubuntu/catkin_ws/src/my_robot/worlds/this_world.world
export TURTLEBOT_GAZEBO_MAP_FILE=/home/ubuntu/catkin_ws/src/my_robot/maps/map.yaml

xterm -hold -e "source /opt/ros/noetic/setup.bash; source /home/ubuntu/catkin_ws/devel/setup.bash; export TURTLEBOT_3D_SENSOR=kinect; export GAZEBO_PLUGIN_PATH=/home/ubuntu/catkin_ws/devel/lib:/opt/ros/noetic/lib; export TURTLEBOT_GAZEBO_WORLD_FILE=/home/ubuntu/catkin_ws/src/my_robot/worlds/this_world.world; roslaunch turtlebot_gazebo turtlebot_world.launch" &
sleep 5
xterm -hold -e "source /opt/ros/noetic/setup.bash; source /home/ubuntu/catkin_ws/devel/setup.bash; export TURTLEBOT_3D_SENSOR=kinect; export TURTLEBOT_GAZEBO_MAP_FILE=/home/ubuntu/catkin_ws/src/my_robot/maps/map.yaml; roslaunch turtlebot_gazebo amcl_demo.launch" &
sleep 5
xterm -hold -e "source /opt/ros/noetic/setup.bash; source /home/ubuntu/catkin_ws/devel/setup.bash; roslaunch turtlebot_rviz_launchers view_navigation.launch" &
