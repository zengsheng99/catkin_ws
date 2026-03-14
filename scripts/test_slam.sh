#!/bin/sh
# Launch turtlebot inside your world
xterm -e "source /opt/ros/noetic/setup.bash; source /home/ubuntu/catkin_ws/devel/setup.bash; roslaunch turtlebot_gazebo turtlebot_world.launch; bash" &
sleep 5

# Launch gmapping SLAM
xterm -e "source /opt/ros/noetic/setup.bash; source /home/ubuntu/catkin_ws/devel/setup.bash; roslaunch turtlebot_gazebo gmapping_demo.launch; bash" &
sleep 5

# Launch RViz navigation view
xterm -e "source /opt/ros/noetic/setup.bash; source /home/ubuntu/catkin_ws/devel/setup.bash; roslaunch turtlebot_rviz_launchers view_navigation.launch; bash" &
sleep 5

# Launch keyboard teleop
xterm -e "source /opt/ros/noetic/setup.bash; source /home/ubuntu/catkin_ws/devel/setup.bash; roslaunch turtlebot_teleop keyboard_teleop.launch; bash" &
