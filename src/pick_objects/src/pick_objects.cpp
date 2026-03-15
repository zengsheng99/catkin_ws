#include <ros/ros.h>
#include <move_base_msgs/MoveBaseAction.h>
#include <actionlib/client/simple_action_client.h>

typedef actionlib::SimpleActionClient<move_base_msgs::MoveBaseAction> MoveBaseClient;

bool sendGoal(MoveBaseClient& ac, double x, double y, const std::string& label) {
  move_base_msgs::MoveBaseGoal goal;
  goal.target_pose.header.frame_id = "map";
  goal.target_pose.header.stamp = ros::Time::now();
  goal.target_pose.pose.position.x = x;
  goal.target_pose.pose.position.y = y;
  goal.target_pose.pose.orientation.w = 1.0;

  ROS_INFO("Heading to %s (%.1f, %.1f)...", label.c_str(), x, y);
  ac.sendGoal(goal);
  ac.waitForResult();

  if (ac.getState() == actionlib::SimpleClientGoalState::SUCCEEDED) {
    ROS_INFO("Reached %s!", label.c_str());
    return true;
  }
  ROS_WARN("Failed to reach %s.", label.c_str());
  return false;
}

int main(int argc, char** argv) {
  ros::init(argc, argv, "pick_objects");

  MoveBaseClient ac("move_base", true);

  while (!ac.waitForServer(ros::Duration(5.0))) {
    ROS_INFO("Waiting for the move_base action server to come up");
  }

  // 2x2 grid around spawn (-4, -4), 2-unit offsets
  // NE → NW → SW → SE
  // NE: pickup zone
  if (!sendGoal(ac, -4.0, 5.0, "pickup zone"))
    return 1;
  ROS_INFO("Waiting 5 seconds at pickup zone...");
  ros::Duration(5.0).sleep();

  // NW
  sendGoal(ac, -6.0, -2.0, "waypoint NW");

  // SW: drop off zone
  if (!sendGoal(ac, -6.0, -6.0, "drop off zone (SW)"))
    return 1;
  ROS_INFO("Waiting 5 seconds at drop off zone...");
  ros::Duration(5.0).sleep();

  // SE
  sendGoal(ac, -2.0, -6.0, "waypoint SE");

  ROS_INFO("2x2 movement sequence complete.");
  return 0;
}
