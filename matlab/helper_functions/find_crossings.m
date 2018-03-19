function [ incomingList ] = find_crossings(bots)
% Author: Nathaniel Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%
% Purpose: Identify bots that might be about to cross from one Kinect's
% field of view to another.

%% Globals and variable initializations
global kinect_locations;
global camDistToFloor;
numKinects = length(kinect_locations);

% Reset the incoming lists to start fresh
incomingList = strings(numKinects,1);

%% Parse through all of the bots
% Check to see which ones have a hysteresis value greater than 1. 
% If the bot hasn't been found twice, then it has likely crossed some
% boundary.
for i = 1:length(bots)
    if bots(i).hyst > 1
        % Calculate which two Kinects are the closest (one should be the
        % Kinect it is currently assigned to)
        x = bots(i).X;
        y = bots(i).Y;
        z = bots(i).Z;
        closestDist = 100000000;
        closestKinect = 0;
        closestDist2 = 1000000000;
        closestKinect2 = 0;
        for j = 1:numKinects
            kinectX = kinect_locations(i,1);
            kinectY = kinect_locations(i,2);
            kinectZ = camDistToFloor;
            dist = sqrt((kinectX-x)^2 + (kinectY-y)^2 + (kinectZ-z)^2);
            if dist < closestDist2
                if dist < closestDist
                    closestDist2 = closestDist;
                    closestKinect2 = closestKinect;
                    closestDist = dist;
                    closestKinect = i;
                else
                    closestDist2 = dist;
                    closestKinect2 = i;
                end
            end
        end
        
        % Add them to the list of each Kinect as described in the
        % documentation
        incomingList(closestKinect) = strcat(incomingList(closestKinect),...
            num2str(i), ',');
        if closestKinect2 > 0
            incomingList(closestKinect2) = strcat(incomingList(closestKinect2),...
                num2str(i), ',');
        end
    end
end

end

