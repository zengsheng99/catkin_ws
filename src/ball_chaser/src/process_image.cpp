#include "ros/ros.h"
#include "ball_chaser/DriveToTarget.h"
#include <sensor_msgs/Image.h>

// Define a global client that can request services
ros::ServiceClient client;

// This function calls the command_robot service to drive the robot in the specified direction
void drive_robot(float lin_x, float ang_z)
{
    // TODO: Request a service and pass the velocities to it to drive the robot
    ball_chaser::DriveToTarget srv;
    srv.request.linear_x = lin_x;
    srv.request.angular_z = ang_z;
    
    if (!client.call(srv))
    {
    	ROS_ERROR("Failed to call service /ball_chaser/command_robot");
    }
}

// This callback function continuously executes and reads the image data
void process_image_callback(const sensor_msgs::Image img)
{

    int white_pixel = 255;

    // TODO: Loop through each pixel in the image and check if there's a bright white one
    if (img.encoding.empty() || img.data.empty())
    {
    	drive_robot(0.0, 0.0);
    	return;
    }
    
    // Then, identify if this pixel falls in the left, mid, or right side of the image
    const int width = static_cast<int>(img.width);
    const int height = static_cast<int>(img.height);
    
    if (img.step < img.width * 3)
    {
    	ROS_WARN_THROTTLE(1.0, "Unexpected image step/format; stopping.");
    	drive_robot(0.0,0.0);
    	return;
    }
    
    const int left_end = width / 3;
    const int middle_end = 2 * width / 3;
    
    bool found_left = false, found_mid = false, found_right = false;
    
    for (int r = 0; r < height; r++)
    {
    	const int row_start = r * img.step;
    	
    	for (int c = 0; c < width; c++)
    	{
    		const int idx = row_start + c * 3;
    		const uint8_t R = img.data[idx + 0];
    		const uint8_t G = img.data[idx + 1];
    		const uint8_t B = img.data[idx + 2];
    		
    		if (R == white_pixel && G == white_pixel && B == white_pixel)
    		{
    			if (c < left_end)		found_left = true;
    			else if (c < middle_end)	found_mid = true;
    			else				found_right = true;
    			
    			r = height;
    			break;
    		}
    	}
    }
    // Depending on the white ball position, call the drive_bot function and pass velocities to it
    if (found_left)
    {
    	ROS_INFO_THROTTLE(0.5, "Ball on LEFT -> turn LEFT");
    	drive_robot(0.2,0.5);
    }
    else if (found_mid)
    {
    	ROS_INFO_THROTTLE(0.5, "Ball on MIDDLE -> go forward");
    	drive_robot(0.3,0.0);
    }
    else if (found_right)
    {
    	ROS_INFO_THROTTLE(0.5, "Ball on RIGHT -> turn RIGHT");
    	drive_robot(0.2,-0.5);
    }     
    // Request a stop when there's no white ball seen by the camera
    else
    {
    	ROS_INFO_THROTTLE(0.5, "No ball -> stop");
    	drive_robot(0.0,0.0);
    }
}

int main(int argc, char** argv)
{
    // Initialize the process_image node and create a handle to it
    ros::init(argc, argv, "process_image");
    ros::NodeHandle n;

    // Define a client service capable of requesting services from command_robot
    client = n.serviceClient<ball_chaser::DriveToTarget>("/ball_chaser/command_robot");

    // Subscribe to /camera/rgb/image_raw topic to read the image data inside the process_image_callback function
    ros::Subscriber sub1 = n.subscribe("/camera/rgb/image_raw", 10, process_image_callback);

    // Handle ROS communication events
    ros::spin();

    return 0;
}
