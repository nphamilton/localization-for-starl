function check_incoming(incomingList, kinectNum, imgColor, imgDepth)
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: To check fringes for possible crossing over of robots from
% outside the field of view to inside the field of view.

global bots
global bot_lists
factor = 3.0;

%% Parse the incoming list
botList = str2num(incomingList);

%% Search the image for incomming robots and update lists
for i = botList
    prevKinectNum = bots(i).kinectNum;
    
    % Determine what pixel location the robot will be at
    [center, radius] = getPixelCoord(kinectNum, i, bots(i).X, bots(i).Y, bots(i).Z);
    
    % Capture a space around the robot and search it for the specified
    % robot
    bots(robotNums(i)).BBox = getBBox(center, radius, bots(robotNums(i)).type, factor);
    trackBots(imgColor, imgDepth, robotNums(i), kinectNum);
    
    % If the robot was found, then the corresponding bot_lists need to be
    % updated
    if bots(i).hyst == 0
        % Remove the number from the previous Kinect's list
        bot_lists(prevKinectNum) = strrep(bot_lists(prevKinectNum), ...
            num2str(i), '');
        % Remove any double commas
        bot_lists(prevKinectNum) = strrep(bot_lists(prevKinectNum), ...
            ',,', ',');
        
        % Add the robot number to the new list where it was found
        bot_lists(kinectNum) = strcat(bot_lists(kinectNum), ',', num2str(i));
    end
end

end

