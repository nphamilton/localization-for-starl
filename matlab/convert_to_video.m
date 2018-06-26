function [] = convert_to_video( fileName )
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: The purpose of this function is to convert the previous run's 
% information into an avi video format.
% 

%% Declare global variables for use
global frameData
global frameCount

%% Open the video writer
vw = VideoWriter(fileName);
open(vw);

%% Write each frame into the video
for i =  1:frameCount
    frame = frameData(:,:,:,i);
    writeVideo(vw, frame);
end

%% Close the video writer
close(vw);


end