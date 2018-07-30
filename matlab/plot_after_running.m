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
I = create_camera_frame(imgColorAll(:,:,:,1,1),1,1,goal_centers,goal_radii,showCoordinates,videoOnly, showBBox);
[numRows, numCols, ~] = size(I);
% The first camera's bounds
rowMin(2) = 1;
rowMax(2) = numRows;
columnMin(2) = 1;
columnMax(2) = numCols;
% The second camera's bounds
rowMin(1) = numRows+1;
rowMax(1) = numRows*2;
columnMin(1) = 1;
columnMax(1) = numCols;

%% Create the big picture
% Preallocate the space
frameData = zeros(max(rowMax),max(columnMax),3,frameCount,'uint8');

% Go frame by frame and camera by camera
for frame_num = 1:frameCount
   for camera_num = 1:numCameras
%        figure(2);
       I = create_camera_frame(imgColorAll(:,:,:,camera_num,frame_num),camera_num,frame_num,goal_centers,goal_radii,showCoordinates,videoOnly, showBBox);
%        imshow(I);
%        pause();
       frameData(rowMin(camera_num):rowMax(camera_num),columnMin(camera_num):columnMax(camera_num),:,frame_num) ...
           = I;
   end
%    figure(3);
%    p = frameData(:,:,:,frame_num);
%    imshow(p);
%    pause();
end
