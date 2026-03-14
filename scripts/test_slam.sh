#!/bin/sh
# Launch Gazebo world with robot
xterm -e "source /opt/ros/noetic/setup.bash; source /home/ubuntu/catkin_ws/devel/setup.bash; roslaunch my_robot world.launch" &
sleep 5

# Launch SLAM (mapping)
xterm -e "source /opt/ros/noetic/setup.bash; source /home/ubuntu/catkin_ws/devel/setup.bash; roslaunch my_robot mapping.launch" &
sleep 5

# Launch teleop for keyboard control
xterm -e "source /opt/ros/noetic/setup.bash; rosrun teleop_twist_keyboard teleop_twist_keyboard.py" &

