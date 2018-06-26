% plot_after_running.m
%
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: The purpose of this function is to record the information from
% the previous run into a compressed format to be converted into video
% format if desired.
%

%% Declare global variables
global frameData
global frameCount
global mm_per_pixel
global numCameras

%% Declare setting variables
showCoordinates = 1;
showBBox = 1;
videoOnly = 0; % 0 - show detected circles 1 - just get video, no plotting
goal_radius = 50;

%% Get the waypoint information
if ~isempty(waypoints)
    goal_centers = [];
    goal_radii = [];
    for i = 1:size(waypoints,2)
        goal_centers = [goal_centers; waypoints(i).X, waypoints(i).Y];
        goal_radii = [goal_radii; goal_radius];
    end
else
    goal_centers = 0;
    goal_radii = 0;
end
% This feature will be added later
goal_centers = 0;
goal_radii = 0;

%% Determine where the camera's images should be positioned in the big picture
% Figure out how to do this without
% hardcoding!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% The first camera's bounds
rowMin(1) = 1;
rowMax(1) = 1080;
columnMin(1) = 1;
columnMax(1) = 1920;
% The second camera's bounds
rowMin(2) = 1081;
rowMax(2) = 1080*2;
columnMin(2) = 1921;
columnMax(2) = 1920*2;

%% Create the big picture
% Preallocate the space
frameData = zeros(max(rowMax),max(columnMax),3,frameCount);

% Go frame by frame and camera by camera
for frame_num = 1:frameCount
   for camera_num = 1:numCameras
       frameData(rowMin(camera_num):rowMax(camera_num),columnMin(camera_num):columnMax(camera_num),:,frame_num) ...
           = create_camera_frame(imgColorAll(:,:,:,camera_num,frame_num),frame_num,goal_centers,goal_radii,showCoordinates,videoOnly, showBBox);
   end
end
