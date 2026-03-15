#include <ros/ros.h>
#include <visualization_msgs/Marker.h>

int main(int argc, char** argv) {
  ros::init(argc, argv, "add_markers");
  ros::NodeHandle n;
  ros::Publisher marker_pub = n.advertise<visualization_msgs::Marker>("visualization_marker", 1);

  // Wait for rviz to subscribe
  while (marker_pub.getNumSubscribers() < 1) {
    if (!ros::ok()) return 0;
    ROS_WARN_ONCE("Waiting for rviz to subscribe to /visualization_marker...");
    ros::Duration(0.5).sleep();
  }

  visualization_msgs::Marker marker;
  marker.header.frame_id    = "map";
  marker.ns                 = "add_markers";
  marker.id                 = 0;
  marker.type               = visualization_msgs::Marker::CUBE;
  marker.pose.orientation.w = 1.0;
  marker.scale.x            = 0.3;
  marker.scale.y            = 0.3;
  marker.scale.z            = 0.3;
  marker.color.r            = 0.0f;
  marker.color.g            = 1.0f;
  marker.color.b            = 0.0f;
  marker.color.a            = 1.0f;

  // Step 1: Publish marker at pickup zone
  marker.action          = visualization_msgs::Marker::ADD;
  marker.pose.position.x = -4.0;
  marker.pose.position.y =  5.0;
  marker.pose.position.z =  0.0;
  marker.header.stamp    = ros::Time::now();
  ROS_INFO("Showing marker at pickup zone (-4.0, 5.0)");
  marker_pub.publish(marker);

  // Step 2: Pause 5 seconds
  ros::Duration(5.0).sleep();

  // Step 3: Hide the marker
  marker.action       = visualization_msgs::Marker::DELETE;
  marker.header.stamp = ros::Time::now();
  marker_pub.publish(marker);
  ROS_INFO("Marker hidden");

  // Step 4: Pause 5 seconds
  ros::Duration(5.0).sleep();

  // Step 5: Publish marker at drop off zone
  marker.action          = visualization_msgs::Marker::ADD;
  marker.pose.position.x = -4.0;
  marker.pose.position.y =  4.0;
  marker.pose.position.z =  0.0;
  marker.header.stamp    = ros::Time::now();
  ROS_INFO("Showing marker at drop off zone (-4.0, 4.0)");
  marker_pub.publish(marker);

  ros::spin();
  return 0;
}
