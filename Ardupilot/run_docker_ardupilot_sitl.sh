# enable access to xhost from the container
xhost +local:root
cwd=$(pwd)"/ardupilot"

# Run docker and open bash shell
# make sure to provide correct path for volumes
sudo docker run -it --privileged \
--env=LOCAL_USER_ID="$(id -u)" \
--rm \
--gpus all \
-v cwd:/ardupilot/:rw \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-e DISPLAY=$DISPLAY \
-e QT_X11_NO_MITSHM=1 \
-p 14556:14556/udp \
--name=mycontainer ardupilot-nvidia \
bash

# cd ardupilot
# make px4_sitl gazebo_tiltrotor
