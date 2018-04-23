function [botID_list, kinectID_list, waypoint_filename] = parse_input(fileName)
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: The purpose of this function is to parse through the input file
% name for all of the robot information.
% 
% The input file is setup with the following format:
%
% WAYPOINT_FILE_NAME
% numBots numKinects
% Kinect 1 X Y
% botName type color
% botName type color
% Kinect 2 X Y
% botName type color
% .
% .

global numKinects
global numBots
global bots
global bot_lists
global kinect_locations

%% Open the file
f = fopen(fileName,'r');

%% Read the waypoint file name
firstline = fgets(f);
C = textscan(firstline, '%s');
waypoint_filename = string(C{1});

%% Read the number of kinects and robots
secondline = fgets(f);
C = textscan(secondline,'%d %d');
numBots = C{1};
numKinects = C{2};

%% Initialize the array of bots
bots = Robot.empty(numBots,0);
for i = 1:numBots
    bots(i) = Robot;
end

%% Initialize the Kinect locations matrix
kinect_locations = zeros(numKinects,3);

%% Initialize the bot lists
bot_lists = strings(numKinects,1);
list = "";
botID_list = "";
kinectID_list = "";

%% Parse through the file reading one line at a time
botNum = 1;
kinectNum = 1;
nextline = fgets(f);
while ischar(nextline)
    if numel(nextline) > 6
        if strcmp(nextline(1:6),'Kinect') == 1 || strcmp(nextline(1:6), 'kinect') == 1
            % If the line is for declaring the next Kinect number, update
            % the Kinect number
            C = textscan(nextline,'%s %d %d %d %d');
            
            % But first, clean up the previous Kinect's bot list by
            % removing the last comma
            if strcmp(list,'') == 0
                bot_lists(kinectNum) = strip(list, 'right', ',');
                list = "";
            end
            
            % Update the Kinect number
            kinectNum = C{2};
            kinect_locations(kinectNum,1) = C{3};
            kinect_locations(kinectNum,2) = C{4};
            kinect_locations(kinectNum,3) = C{5};
            kinectID_list = strcat(kinectID_list, num2str(C{2}), ':', num2str(C{3}), ':', num2str(C{4}), ':', num2str(C{5}), ',');
            
        else
            % Otherwise the line is for declaring a robot
            C = textscan(nextline,'%s %s %s');
            %assign the info to the appropriate spot in bots
            bots(botNum).name = string(C{1});                                        %THIS LINE HAS PROBLEMS!!!!
            bots(botNum).type = type_name2num(C{2});
            bots(botNum).color = string(C{3});
            bots(botNum).kinectNum = kinectNum;
            
            % Update the appropriate bot_list
            list = strcat(list, num2str(botNum), ',');
            
            % Add it to the botID_list
            botID_list = strcat(botID_list, C{1}, ':', num2str(bots(botNum).type), ':', C{3}, ',');
            
            % Increment to the next bot
            botNum = botNum + 1; 
        end
    end
    nextline = fgets(f);
end

%% All of the bots have been read. Clean up the lists.
% Make sure the last list does not have a trailing ',' 
if strcmp(list,'') == 0
    bot_lists(kinectNum) = strip(list, 'right', ',');
end

% Make sure the botID_list does not have a trailing ','
if strcmp(botID_list,',') == 0
%     disp('hello');
    t = botID_list;
    botID_list = strip(t, 'right', ',');
end

% Make sure the kinectID_list does not have a trailing ','
if strcmp(kinectID_list,',') == 0
%     disp('hello');
    t = kinectID_list;
    kinectID_list = strip(t, 'right', ',');
end

%% Close the file
fclose(f);
end

