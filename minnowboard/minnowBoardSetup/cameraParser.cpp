/*
 * cameraParser.cpp
 * Author: Nate Hamilton
 *  Email: nathaniel.p.hamilton@vanderbilt.edu
 *
 *
 * Purpose:
 *
 * Note: This file is a modification of the Protonect.cpp file found at
 * 	 http://www.openkinect.org for use with libfreenect2
 */

#include <iostream>
#include <cstdlib>
#include <signal.h>
#include <time.h>
#include <stdio.h>

/// [headers]
#include <libfreenect2/libfreenect2.hpp>
#include <libfreenect2/frame_listener_impl.h>
#include <libfreenect2/registration.h>
#include <libfreenect2/packet_pipeline.h>
#include <libfreenect2/logger.h>

#include <opencv2/opencv.hpp>

void delay(unsigned int sec);

bool cameraParser_shutdown = false; ///< Whether the running application should shut down.

void sigint_handler(int s)
{
  cameraParser_shutdown = true;
}

bool cameraParser_paused = false;
libfreenect2::Freenect2Device *devtopause;

//Doing non-trivial things in signal handler is bad. If you want to pause,
//do it in another thread.
//Though libusb operations are generally thread safe, I cannot guarantee
//everything above is thread safe when calling start()/stop() while
//waitForNewFrame().
void sigusr1_handler(int s)
{
  if (devtopause == 0)
    return;
/// [pause]
  if (cameraParser_paused)
    devtopause->start();
  else
    devtopause->stop();
  cameraParser_paused = !cameraParser_paused;
/// [pause]
}


int main()
/// [main]
{

/// [context]
  libfreenect2::Freenect2 freenect2;
  libfreenect2::Freenect2Device *dev = 0;
  libfreenect2::PacketPipeline *pipeline = 0;
/// [context]

  std::string serial = "";

  
/// [discovery]
  if(freenect2.enumerateDevices() == 0)
  {
    std::cout << "no device connected!" << std::endl;
    return -1;
  }

  if (serial == "")
  {
    serial = freenect2.getDefaultDeviceSerialNumber();
  }
/// [discovery]

  if(pipeline)
  {
/// [open]
    dev = freenect2.openDevice(serial, pipeline);
/// [open]
  }
  else
  {
    dev = freenect2.openDevice(serial);
  }

  if(dev == 0)
  {
    std::cout << "failure opening device!" << std::endl;
    return -1;
  }

  devtopause = dev;

  signal(SIGINT,sigint_handler);
#ifdef SIGUSR1
  signal(SIGUSR1, sigusr1_handler);
#endif
  cameraParser_shutdown = false;

/// [listeners]
  int types = 0;
  types |= libfreenect2::Frame::Color;
  types |= libfreenect2::Frame::Ir | libfreenect2::Frame::Depth;
  libfreenect2::SyncMultiFrameListener listener(types);
  libfreenect2::FrameMap frames;

  dev->setColorFrameListener(&listener);
  dev->setIrAndDepthFrameListener(&listener);
/// [listeners]

/// [start]
  if (!dev->start())
    return -1;

  std::cout << "device serial: " << dev->getSerialNumber() << std::endl;
  std::cout << "device firmware: " << dev->getFirmwareVersion() << std::endl;
/// [start]

/// [registration setup]
  libfreenect2::Registration* registration = new libfreenect2::Registration(dev->getIrCameraParams(), dev->getColorCameraParams());
  libfreenect2::Frame undistorted(512, 424, 4), registered(512, 424, 4);
/// [registration setup]

  unsigned int framecount = 0;
  
/// [new directories for each time program is run] 
  time_t now = time(0);
  tm *ltm = localtime(&now);
  char folderName [50]; 
  char rgbDir [50]; 
  char depthDir [50]; 
  char command1 [100]; 
  char command2 [100]; 
  char command3 [100];  
  sprintf(folderName, "Test_time_%d_%d_%d_%d:%d:%d",(1900 + ltm->tm_year),(1 + ltm->tm_mon),(ltm->tm_mday),(ltm->tm_hour),(1 + ltm->tm_min),(1 + ltm->tm_sec));  
  sprintf(rgbDir, "%s/rgbImages",folderName);  
  sprintf(depthDir, "%s/depthImages",folderName); 
  sprintf(command1, "mkdir -p %s",folderName); 
  sprintf(command2, "mkdir -p %s",rgbDir); 
  sprintf(command3, "mkdir -p %s",depthDir); 
  system(command1);  
  system(command2);  
  system(command3);  

/// [loop start]
  while(!cameraParser_shutdown)
  {
    if (!listener.waitForNewFrame(frames, 10*1000)) // 10 seconds
    {
      std::cout << "timeout!" << std::endl;
      return -1;
    }
    libfreenect2::Frame *rgb = frames[libfreenect2::Frame::Color];
    libfreenect2::Frame *ir = frames[libfreenect2::Frame::Ir];
    libfreenect2::Frame *depth = frames[libfreenect2::Frame::Depth];
/// [loop start]

/// [registration]
      registration->apply(rgb, depth, &undistorted, &registered);
/// [registration]
	
    cv::Mat rgbMat = cv::Mat(rgb->height, rgb->width, CV_8UC4, rgb->data);
    cv::Mat irMat = cv::Mat(ir->height, ir->width, CV_32FC1, ir->data);
    cv::Mat depthMat = cv::Mat(depth->height, depth->width, CV_32FC1, depth->data);

//    registration->apply(rgb, depth, &undistorted, &registered, true, &registeredInv);

//    cv::Mat undistortedMat = cv::Mat(undistorted.height, undistorted.width, CV_32FC1, undistorted.data);
//    cv::Mat registeredMat = cv::Mat(registered.height, registered.width, CV_8UC4, registered.data);
//    cv::Mat registeredInvMat = cv::Mat(registeredInv.height, registeredInv.width, CV_32FC1, registeredInv.data);    

    char rgbName [50];
	char depthName [50];
	sprintf(rgbName, "%s/image%06u.jpg",rgbDir,framecount);
	sprintf(depthName, "%s/image%06u.jpg",depthDir,framecount);
	cv::imwrite(rgbName, rgbMat);
    cv::imwrite(depthName, depthMat);
	
	framecount++;

/// [loop end]
    listener.release(frames);
    /*libfreenect2::this_thread::sleep_for(libfreenect2::chrono::milliseconds(250));*/

// Sleep for a moment so that MatLab has time to read the files
//    delay(250);
  }
/// [loop end]

  // TODO: restarting ir stream doesn't work!
  // TODO: bad things will happen, if frame listeners are freed before dev->stop() :(
/// [stop]
  dev->stop();
  dev->close();
/// [stop]

  delete registration;

  return 0;
}

void delay(unsigned int sec) {
  clock_t ticks1 = clock()*1000;
  clock_t ticks2 = ticks1;
  while((ticks2/CLOCKS_PER_SEC - ticks1/CLOCKS_PER_SEC) < sec) {
    ticks2 = clock()*1000;
  }
}
