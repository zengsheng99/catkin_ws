# Home Service Robot

A ROS-based home service robot that autonomously navigates an indoor environment to perform pick-up and drop-off tasks. The robot uses SLAM for mapping, AMCL for localization, and the ROS navigation stack for path planning and obstacle avoidance. Virtual markers in RViz visualize the object being picked up and delivered.

## Packages Used

### Mapping
- **slam_gmapping**: Implements the GMapping SLAM algorithm, which uses a Rao-Blackwellized particle filter to build a 2D occupancy grid map from laser scan and odometry data. The robot is teleoperated through the environment while gmapping incrementally constructs the map in real time.

### Localization
- **turtlebot_gazebo (amcl_demo)**: Launches Adaptive Monte Carlo Localization (AMCL), a probabilistic localization system that uses a particle filter to track the robot's pose against a known map. AMCL subscribes to laser scans and updates the particle distribution as the robot moves, converging on the true pose over time.

### Navigation
- **turtlebot_navigation (move_base)**: Provides the ROS navigation stack with global and local planners. The global planner (NavfnROS) computes an optimal path using Dijkstra's algorithm on the costmap, while the local planner (TrajectoryPlannerROS) generates velocity commands to follow the path while avoiding dynamic obstacles.

### Simulation
- **turtlebot_gazebo**: Launches the TurtleBot robot model in a Gazebo simulation environment with a Kinect depth sensor that provides RGB-D data converted to laser scans for SLAM and navigation.
- **turtlebot_simulator**: Contains Gazebo plugins and launch files for spawning the TurtleBot (Kobuki base) in simulation with physics, sensors, and actuators.

### Visualization
- **turtlebot_rviz_launchers**: Provides pre-configured RViz launch files for visualizing the robot, map, laser scans, costmaps, and navigation goals during testing and operation.
- **turtlebot_interactions**: Contains RViz configurations and interactive tools for the TurtleBot platform.

### Teleoperation
- **teleop_twist_keyboard**: Publishes Twist velocity commands from keyboard input, used during SLAM mapping to manually drive the robot through the environment for map generation.

### Robot Platform
- **turtlebot**: Core TurtleBot meta-package providing robot description, bringup, and configuration for the Kobuki mobile base with a Kinect 3D sensor.
- **kobuki_description**: URDF/Xacro model of the Kobuki mobile base used by the TurtleBot, defining its geometry, joints, and sensor mounts.

### Custom Packages
- **pick_objects**: Sends sequential navigation goals to the move_base action server to autonomously drive the robot to a pickup zone, wait 5 seconds, then navigate to a drop-off zone.
- **add_markers**: Publishes RViz visualization markers to simulate object pick-up and drop-off. The service version (`add_markers_service`) subscribes to `/amcl_pose` and uses a state machine to show/hide markers based on robot proximity to the pickup and drop-off locations.
- **my_robot**: Contains the robot's Gazebo world file, saved map files, AMCL launch configuration, and navigation costmap parameters.

## How to Run

### 1. Build the Workspace

```bash
cd ~/catkin_ws
catkin_make
source devel/setup.bash
```

### 2. Test SLAM Mapping

Generate a map of the environment using GMapping SLAM:

```bash
./scripts/test_slam.sh
```

This launches Gazebo with the project world, the GMapping SLAM node, RViz, and keyboard teleoperation. Use the keyboard teleop window to drive the robot around the entire environment. Observe the map being built in real time in RViz.

Once the map is complete, save it by running in a new terminal:

```bash
source devel/setup.bash
rosrun map_server map_saver -f $(pwd)/src/my_robot/maps/map
```

This saves `map.pgm` and `map.yaml` to `src/my_robot/maps/`, which are then used by all other scripts for localization and navigation.

**Expected output**: Gazebo opens with the indoor environment. As you drive the robot, the occupancy grid map builds progressively in RViz. After saving, you have a complete map for AMCL.

### 3. Test Navigation

Verify the robot can receive and reach 2D Nav Goals:

```bash
./scripts/test_navigation.sh
```

**Expected output**: Gazebo and RViz open with the pre-built map loaded. The robot localizes using AMCL. You can send 2D Nav Goals in RViz and the robot navigates to them autonomously.

### 4. Pick Objects

Test autonomous navigation to pickup and drop-off zones:

```bash
./scripts/pick_objects.sh
```

**Expected output**: The robot autonomously navigates to the pickup zone (-4.0, 5.0), prints "Reached pickup zone", waits 5 seconds, then navigates to the drop-off zone (-4.0, 4.0) and prints "Reached drop-off zone".

### 5. Add Markers

Test marker visualization at pickup and drop-off zones:

```bash
./scripts/add_markers.sh
```

**Expected output**: A green cube marker appears at the pickup zone in RViz, disappears after 5 seconds (simulating pickup), then reappears at the drop-off zone after another 5 seconds.

### 6. Home Service (Full Demo)

Run the complete home service robot workflow:

```bash
./scripts/home_service.sh
```

**Expected output**: The robot navigates to the pickup zone where a marker is displayed. Upon arrival, the marker disappears (object picked up) and the robot waits 5 seconds. It then navigates to the drop-off zone, where the marker reappears (object delivered). The full pick-up and delivery cycle completes autonomously.

## Key Parameters

### AMCL Localization
- **min_particles / max_particles**: 500 / 5000 — range of particles for pose estimation
- **odom_model_type**: diff-corrected — odometry model suited for differential drive robots
- **laser_model_type**: likelihood_field — efficient laser model comparing scans against the map

### Navigation Costmaps
- **global_costmap**: 20x20m static map at 0.05m resolution, used for global path planning
- **local_costmap**: 10x10m rolling window at 0.05m resolution, used for local obstacle avoidance
- **inflation_radius**: 0.5m — buffer zone around obstacles for safe path planning

### GMapping SLAM
- **particles**: 80 — number of particles in the Rao-Blackwellized filter
- **linearUpdate / angularUpdate**: 0.3m / 0.436rad — minimum motion before processing a new scan
- **maxUrange**: 6.0m — maximum usable range of the laser scanner

