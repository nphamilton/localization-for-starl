#!/bin/bash
echo -e "\033[01;33m\033[1m\033[4m SETTING UP KINECT IMAGE PARSER... \033[00m"
sudo rm -r build
mkdir build
cd build
cmake ..
make
echo -e "\033[01;33m\033[1m\033[4m FINISHED SETTING UP KINECT IMAGE PARSER... \033[00m"
