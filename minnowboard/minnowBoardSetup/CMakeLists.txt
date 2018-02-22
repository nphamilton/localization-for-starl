cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
project("My Project")

set(CMAKE_CXX_FLAGS "-std=c++11")
# Set cmake prefix path to enable cmake to find freenect2
set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} $ENV{HOME}/freenect2/lib/cmake/freenect2)
find_package(freenect2 REQUIRED)

# Set cmake prefix path to enable cmake to find openCV
find_package(OpenCV REQUIRED)

include_directories("/usr/include/libusb-1.0/")

INCLUDE_DIRECTORIES(
	${freenect2_INCLUDE_DIR}
	${OpenCV_INCLUDE_DIR}
)

add_executable(cameraParser ./cameraParser.cpp)

target_link_libraries(cameraParser ${freenect2_LIBRARIES} ${OpenCV_LIBS})
