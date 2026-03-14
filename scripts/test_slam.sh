#!/bin/sh
# Launch turtlebot inside your world
xterm -hold -e "source /opt/ros/noetic/setup.bash; source /home/ubuntu/catkin_ws/devel/setup.bash; roslaunch turtlebot_gazebo turtlebot_world.launch" &
sleep 5

# Launch gmapping SLAM
xterm -hold -e "source /opt/ros/noetic/setup.bash; source /home/ubuntu/catkin_ws/devel/setup.bash; roslaunch turtlebot_gazebo gmapping_demo.launch" &
sleep 5

# Launch RViz navigation view
xterm -hold -e "source /opt/ros/noetic/setup.bash; source /home/ubuntu/catkin_ws/devel/setup.bash; roslaunch turtlebot_rviz_launchers view_navigation.launch" &
sleep 5

# Launch keyboard teleop
xterm -hold -e "source /opt/ros/noetic/setup.bash; source /home/ubuntu/catkin_ws/devel/setup.bash; roslaunch turtlebot_teleop keyboard_teleop.launch" &
