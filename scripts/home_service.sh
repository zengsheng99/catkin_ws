#!/bin/sh
export TURTLEBOT_3D_SENSOR=kinect
export GAZEBO_PLUGIN_PATH=/home/ubuntu/catkin_ws/devel/lib:/opt/ros/noetic/lib
export TURTLEBOT_GAZEBO_WORLD_FILE=/home/ubuntu/catkin_ws/src/my_robot/worlds/this_world.world
export TURTLEBOT_GAZEBO_MAP_FILE=/home/ubuntu/catkin_ws/src/my_robot/maps/map.yaml
export ROBOT_INITIAL_POSE="-x -4 -y -4 -z 0.0"

xterm -hold -e "source /opt/ros/noetic/setup.bash; source /home/ubuntu/catkin_ws/devel/setup.bash; export TURTLEBOT_3D_SENSOR=kinect; export GAZEBO_PLUGIN_PATH=/home/ubuntu/catkin_ws/devel/lib:/opt/ros/noetic/lib; export TURTLEBOT_GAZEBO_WORLD_FILE=/home/ubuntu/catkin_ws/src/my_robot/worlds/this_world.world; export ROBOT_INITIAL_POSE='-x -4 -y -4 -z 0.0'; roslaunch turtlebot_gazebo turtlebot_world.launch" &
sleep 5
xterm -hold -e "source /opt/ros/noetic/setup.bash; source /home/ubuntu/catkin_ws/devel/setup.bash; export TURTLEBOT_3D_SENSOR=kinect; export TURTLEBOT_GAZEBO_MAP_FILE=/home/ubuntu/catkin_ws/src/my_robot/maps/map.yaml; roslaunch turtlebot_gazebo amcl_demo.launch initial_pose_x:=-4 initial_pose_y:=4" &
sleep 5
xterm -hold -e "source /opt/ros/noetic/setup.bash; source /home/ubuntu/catkin_ws/devel/setup.bash; rosrun rviz rviz -d /home/ubuntu/catkin_ws/src/add_markers/rviz/home_service.rviz" &
sleep 5
xterm -hold -e "source /opt/ros/noetic/setup.bash; source /home/ubuntu/catkin_ws/devel/setup.bash; rosrun pick_objects pick_objects" &
sleep 2
xterm -hold -e "source /opt/ros/noetic/setup.bash; source /home/ubuntu/catkin_ws/devel/setup.bash; rosrun add_markers add_markers" &
