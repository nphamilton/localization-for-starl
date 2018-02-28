% central_command_main.m
%
% Author: Nathaniel Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%
% Purpose:
%
close all;
format longg;

load('run_number.mat')

%% Declare global variables
global disp_waypoints;
global disp_waypoint_names;
global fig_closed;
global clear_history;
global waypoints_transmitted;
global send_launch;
global IP;
global bots;
global bot_lists;
global kinect_locations;
global camDistToFloor;
global BBoxFactor;
global frameCount;
global imgColorAll;
global mm_per_pixel;
global camDistToFloor;
global botArray;
global BBoxFactor;
global hysteresis;
global numKinects
global numBots
global MINIDRONE;
global CREATE2;
global ARDRONE;
global THREEDR;
global GHOST2;
global MAVICPRO;
global PHANTOM3;
global PHANTOM4;

%% Define values for global variables that shouldn't be changed
MINIDRONE = 100;
CREATE2 = 101;
ARDRONE = 102;
THREEDR = 103;
GHOST2 = 104;
MAVICPRO = 105;
PHANTOM3 = 106;
PHANTOM4 = 107;
disp_waypoints = 1;
disp_waypoint_names = 0;
fig_closed = 0;
clear_history = 0;
waypoints_transmitted = 0;
send_launch = 0;

%% Define values for the settings variables. THESE CAN BE CHANGED
BBoxFactor = 1.7; % intentionally large because it is used for searching for drones not found in previous locations
hysteresis = 10;
camDistToFloor = 3058; % in mm, as measured with Kinect
mm_per_pixel = 5.663295322; % mm in one pixel at ground level
IP = '10.255.24.255';
USE_SERVER = 1; %Enable/disable the network server
USE_WPT = 1;    %Enable/disable loading waypoints and walls
USE_HISTORY = 1;%Enable/disable history
BOTLIST_FILENAME = 'robot_list.txt';

% Grid size and spacing parameters
TX_PERIOD = 0.05;	%sec
X_MAX = 3100;       %mm
Y_MAX = 3700;       %mm
LINE_LEN = 167;     %mm (should be iRobot Create radius)

% Path tracing variables
HISTORY_SIZE = 2500; %number of points in each history for drawing

% File export settings
SAVE_TO_FILE = false;
OUTPUT_FILENAME = 'C:\data.xml';

%% Setup the figure and save file
% Setup the figure
fig = figure('KeyPressFcn',@fig_key_handler);

% Setup save file
if(SAVE_TO_FILE)
   fileHandle = fopen(OUTPUT_FILENAME,'w+'); 
end

%% Parse the input and process it
% Open the list and parse through it to create the botID_list
[botID_list, kinectID_list, WPT_FILENAME] = parse_input(BOTLIST_FILENAME);

% Compare input to available nodes and cancel if not all are there
% ****************************************************************** 
% **********************************************

% Load the walls and waypoints (if required)
[walls, waypoints] = load_wpt(WPT_FILENAME, USE_WPT);

% Establish boundaries for each Kinect node
establish_boundaries(kinect_locations);

%% Setup subscribers


%% Display keyboard shortcuts
disp('L - Launch robots');
disp('A - Abort all');
disp('W - Toggle waypoint viewing');
disp('N - Toggle waypoint name viewing');
disp('S - Resend waypoints');
disp('C - Clear history');
disp('X - Exit');
disp('Q - Track shutdown');

%% Find all the robots in their initial positions on the ground
for i = 1:numKinects
    find_robots(bot_lists(i),i); 
end

%% Track the robots and display their position in the figure
frameCount = 0;
while true
    frameCount = frameCount + 1;
    
    % Read all of the kinect images ********************************
    
    % Check each robot's location information for potential boundary crossing
    % and inform the appropriate Kinects of the incident(s)
    find_potential_crossings(bots, incomingPubs);

    % Find the robots in each image ************************************
    
    % Update all the info??? ****************************************
    
    % Update the figure every 4 times
    if rem(frameCount,4) == 1
        plot_bots(fig, LINE_LEN, X_MAX, Y_MAX, bots, waypoints, walls,...
            disp_waypoints, disp_waypoint_names)
    end
    
    % Check the window command for exit command
    % Interpret an exit key press
    if get(fig,'currentkey') == 'x'
        disp('Exiting...');
        close all;
        % Send the shutdown command
        msg = rosmessage('std_msgs/Byte');
		msg.Data = 0;
		send(shutdownPub,msg);
        shutdown_track = 0;
        judp('SEND',4000,IP,int8('ABORT'));
        break;
    end
    
    if get(fig,'currentkey') == 'q'
        disp('Exiting...');
        close all;
        % Send the shutdown command
        msg = rosmessage('std_msgs/Byte');
		msg.Data = 0;
		send(shutdownPub,msg);
        shutdown_track = 1;
        judp('SEND',4000,IP,int8('ABORT'));
        break;
    end

    % If the window command indicates to send waypoints, send them
    if USE_SERVER == 1       
        % Send waypoints and robot positions
         if(waypoints_transmitted == 0)
             waypoints_transmitted = 1;
             server_send_waypoints(waypoints);
             if(SAVE_TO_FILE)
                save_robot_data(bots, fileHandle);
             end
         end

        % If launching the robots
        if send_launch == 1
            server_send_waypoints(waypoints);
            judp('SEND',4000,IP,int8(['GO ' int2str(size(waypoints,2)) ' ' int2str(run_number)]));
            run_number = run_number + 1;
            send_launch = 0;
        end
        
        % If aborting the robots
        if send_launch == -1
            judp('SEND',4000,IP,int8('ABORT'));
            disp('Aborting...');
            send_launch = 0;
            waypoints_transmitted = 1;
        end
    end
end

%% Upon exit...













