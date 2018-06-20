function [center, radius] = getPixelCoord(cameraNum, botNum, X, Y, Z)
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: To convert X, Y, Z coordinates to their corresponding pixel
% locations. It works as a reverse of getMMCoord.
global mm_per_pixel
global camera_locations
global bots
global camDistToFloor

%% Get location information
% these are the center pixel values of the image. If using a camera with
% different resolution than 640x480, this will need to be changed. If (0,0)
% is the center of the image, use them. If the corner is (0,0) then use 0's
% xCenterPx = 320;
% yCenterPx = 240;
xCenterPx = 0;
yCenterPx = 0;

xCenterMM = camera_locations(cameraNum,1);
yCenterMM = camera_locations(cameraNum,2);

%% Determine the type and depth in order to calulate an estimated radius
type = bots(botNum).type;
depth = camDistToFloor - Z;
[rmin, rmax] = findRadiusRange(depth, type);
radius = (rmin + rmax)/2;

%% Calculate the pixel location based on the MM location
center(1,1) = ((X - xCenterMM)/mm_per_pixel) + xCenterPx;
center(1,2) = ((Y - yCenterMM)/mm_per_pixel) + yCenterPx;
end