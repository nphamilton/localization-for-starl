File Name: README.txt
Author: Nate Hamilton
Last Date Edited: 6/5/2017
Purpose: Instructions for setting up a MinnowBoard Turbot with the necessary
		 files for connecting to a Kinect.
Contact info: nathaniel.p.hamilton@vanderbilt.edu

================================================================================
		Using the kinectsetup.bash file to set up your 
	      MinnowBoard Turbot for use with the Microsoft Kinect
================================================================================
1. Move kinectsetup.bash to the home directory

2. Verify the kinectsetup.bash file is executable
	Open terminal and navigate to the home directory then run the command:
	
	chmod +x kinectsetup.bash
	
3. Run kinectsetup.bash as root
	Run the following command and enter the root password
	
	sudo ./kinectsetup.bash
	
4. Wait and watch the updates and installations occur. 
	The script should run without input except for one I could not remove.
	At step 12, installing OpenNI2 it will say
	
	"12) installing OpenNI2...
	Ros packages for Ubuntu Trusty
	More info: https://launchpad.net/~deb-rob/+archive/ubuntu/ros-trusty
	Press [ENTER] to continue or ctrl-c to cancel adding it"
	
	Press enter and the installation will continue through to the end.
	
5. Verify the Kinect connects
	At the end of the script, it will attempt to open a screen showing 
	images from the Kinect. If you don't have the Kinect connected, it will
	just end. If you want to verify the Kinect works, plug one in and run
	the following command:
	
	./bin/Protonect
	
	To exit the program, press the esc key.

================================================================================
				If Issues Occur
================================================================================
In the case where issues occur that you cannot solve on your own, please email 
me with screenshots and any relevent information about the issue and I will try
to help you as best I can.

Nate Hamilton
nathaniel.p.hamilton@vanderbilt.edu
6/5/2017



