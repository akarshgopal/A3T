git submodule update --init --recursive
cd PX4/src
sudo rm -r Firmware
git clone https://github.com/akarshgopal/Firmware.git

cd Firmware
git submodule update --init --recursive
git pull origin a3t_vau_sitl
git checkout a3t_vau_sitl

cd Tools
sudo rm -r sitl_gazebo
git clone https://github.com/akarshgopal/sitl_gazebo.git

cd sitl_gazebo
git submodule update --init --recursive
# pull and switch to sitl directory
git pull origin a3t_vau_sitl
git checkout a3t_vau_sitl

# return to PX4 directory
cd ../../../..
