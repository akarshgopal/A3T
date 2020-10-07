# enable access to xhost from the container
xhost +local:root
cwd=$(pwd)/src/Firmware

# Run docker and open bash shell
# make sure to provide correct path for volumes
sudo docker run -it --privileged \
--env=LOCAL_USER_ID="$(id -u)" \
--rm \
-v $cwd:/src/Firmware/:rw \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-e DISPLAY=$DISPLAY \
-e QT_X11_NO_MITSHM=1 \
-p 14556:14556/udp \
--workdir /src/Firmware \
--name=mycontainer px4io/px4-dev-ros-melodic \
bash

# cd src/Firmware
# make px4_sitl gazebo_a3t_vau