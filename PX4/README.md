
# PX4 Dev Toolchain Docker Setup
## for ros-gazebo on Ubuntu with Nvidia Graphics:

Note: This is only needed if the host system has an Nvidia Graphics card. 

For general px4 dev toolchain container check [here](https://dev.px4.io/master/en/test_and_ci/docker.html)

1. Install Nvidia graphics driver for the host

2. Install docker-ce>=19.03
    - Follow instructions [here](https://docs.docker.com/engine/install/ubuntu/)

3. Install nvidia-docker
    - Follow instructions [here](https://github.com/NVIDIA/nvidia-docker)

4. Clone px4 repo locally.
    ```
    git clone https://github.com/PX4/Firmware.git --recursive
    ```

5. Make sure all pre-requisites are installed:
    ```
    nvidia-smi
    ```
    Should output a table with Nvidia Driver version and other details

    ```
    docker --version
    ```
    Docker version should be greater at least 19.03

    ```
    #### Test nvidia-smi with the latest official CUDA image
    docker run --gpus all nvidia/cuda:10.0-base nvidia-smi
    ```

6. Build docker image w Dockerfile
    ```
    docker build -t px4-dev-sitl-ros-nvidia:latest . 
    ```

7. Run docker using the following commands in terminal:
    ```
    chmod +x run_px4_docker_sitl.sh 
    ./run_px4_docker_sitl.sh 
    ```

8. Enter into Firmware folder and build sitl with custom_model (eg.a3t_vau):
```
    cd src/Firmware
    make px4_sitl gazebo_custom_model
```
Note: if cmakecache error is thrown, run
```
    make clean
```
to clean up any CMake artifacts, and then rerun (8)

## Custom Gazebo Model    
[Instructions](https://discuss.px4.io/t/create-custom-model-for-sitl/6700/4) for Custom Gazebo Model:
The steps I took for creating a custom Gazebo model and PX4 SITL airframe with the adjusted gains:

- Create a folder under Tools/sitl_gazebo/models for your model, let’s call it my_vehicle
- Create the following files under Tools/sitl_gazebo/models/my_vehicle: model.config and my_vehicle.sdf (these can be based off the iris or solo models in Tools/sitl_gazebo/models)
- Create a world file in Tools/sitl_gazebo/worlds called my_vehicle.world (Again, this can be based off the iris or solo world files)
- Create an airframe file under ROMFS/px4fmu_common/init.d-posix (Yet again, this can be based off the iris or solo airframe files), give it a number (for example 4229) and name it 4229_my_vehicle
- Add the airframe name (my_vehicle) to the file platforms/posix/cmake/sitl_target.cmake in the command set(models …

Now you are free to tweak any of the model values in the SDF file and any of the controller gains in the airframe file.
You can launch SITL with your model with “make px4_sitl gazebo_my_vehicle”

A couple of things to keep in mind:

- When increasing the mass of the vehicle, also increase the inertias. I found that Gazebo does not like really small inertias.
- With the larger vehicle, tweak the motor values (but you have done this already)
- If the quad is unstable, it is probably due to bad controller gains. Tweak them for the larger vehicle.


# TODO
- <strike>px4 dev toolchain + ROS Gazebo SITL Dockerfile</strike>
- <strike>include Nvidia drive/ CUDA with display capability in Dockerfile</strike>
- <strike>Test</strike> 
- <strike>Write installation / setup guide </strike>
- Custom Gazebo model for sitl
    - <strike>Build a clone of tiltrotor under another name</strike>
    - Custom Meshes
        - Aileron and elevator meshes 
    - Custom model parameters (sdf)
        - Aerodynamics
            - Wing
            - Aileron
            - Elevator
        - Inertial
            - Mass
            - Moments of Inertia
        - Motor
            - Constants
    - Custom world (location + conditions)
        - Location
        - Map?
        - Magnetic Field

- Improve fidelity of simulation
    - Get all required VAU meshes for visuals
    - Match physical links and joints, limitations etc w VAU
    - Match VAU parameters
    - Write/ edit mixer file accordingly

- Issues:
    - Servos tilt backwards requiring pitch up for hover
        - <strike>Look at sdf file</strike>
            - Motor joint limits: No relevance
            - tilt control limits: Angles are offset, but resolved via mixer file since otherwise transition was problematic w tilt not full range.
        - <strike>Look at mixer file, controller</strike> 
            - tilt servo mapping: motor 2 and motor 4 (rear motors) do not get control inputs
                - motor 1 and motor 3 (front motors) tilt servo offset is ~7000 which corresponds to upright.

    - <strike>Transition requires VAU to move backwards first for some reason, might be the above</strike>
    - <strike>All 4 motors currently tilt</strike>
        - Commented out motor 1 and motor 3 (rear motors) tilts in sdf file
    - Quad Chute doesn't turn on in time
        - being looked at by dev team

    - <strike>Rolls in Autonomous Mission transition</strike>
        - Was most likely gains tuning issue

    - Issues after firmware update:
        - <strike>terrible MC tuning</strike>
        - <strike>crazy pitch when transitioning 2nd time.</strike>
            - All of the above stem from insufficient thrust for hover parameter.
            - Setting the motor constants higher leads to better stability.
            - Tuning PID is still required for fine stability however.
        - <strike>rear servos tilting after quadchute</strike>
        - Mission VTOL transition results in insane yaw, and then crash
            - Happening with regular VTOL transition as well
        - Setting 'go to dest', leads to 1-2 sec of motor off
        - Return flight mode results in motor off for long enough for a crash 


VAU SDF:
- left and right wing basically combine aero properties (per VSP Aero) of Canard and Main wing+Blended fuselage.
    - http://gazebosim.org/tutorials?tut=aerodynamics&cat=physics

- Elevator is taken as single, w Cp at +0.25,0,0 from CG
- Rudder disregarded
- Motor parameters set per:
    - https://github.com/PX4/sitl_gazebo/issues/110
- Guesstimating Inertia values:
    - Ix = 1, Iy = 0.4 ,Ix + Iy = Iz kgm^2
- Need to verify that CoG, and Cp for wings match the openvsp model

(Git management tutorial for PX4)[https://dev.px4.io/master/en/contribute/git_examples.html]
