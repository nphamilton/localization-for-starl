function [ ground_boundaries air_boundaries ] = establish_boundaries( kinectLocations )
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: The purpose of this function is to establish the boundaries of
% each Kinect's field of view based on the Kinect's location. The ground
% boundaries are the entire field of view. The air boundaries are the
% bounds at which the Kinects' field of view overlap.
%
% TODO: make the boundary a function based on height. Might be useful
% later.

% These constants have to be changed for different setups
xRadius = 318/2;
yRadius = 234/2;

[p,numKinects] = size(kinectLocations); % The ans might need to be flipped
bounds = zeros(numKinects,4);

for i = 1:numKinects
    bounds(i,1) = kinectLocations(i,1) - xRadius;
    bounds(i,2) = kinectLocations(i,1) + xRadius;
    bounds(i,3) = kinectLocations(i,2) - yRadius;
    bounds(i,4) = kinectLocations(i,2) + yRadius;
end
ground_boundaries = bounds;

%TODO: Calculate air boundaries
air_boundaries = bounds;
end

