cwd=$(pwd)/src/Firmware

# Run docker and open bash shell
# make sure to provide correct path for volumes
sudo docker run -it --privileged \
--env=LOCAL_USER_ID="$(id -u)" \
--rm \
-v $cwd:/src/Firmware/:rw \
-p 14556:14556/udp \
--workdir /src/Firmware \
--name=mycontainer px4io/px4-dev-nuttx-bionic:2020-04-01 \
bash

# cd src/Firmware
# make px4_sitl gazebo_a3t_vau