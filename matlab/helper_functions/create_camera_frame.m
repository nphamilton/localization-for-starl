function [ plotted_frame ] = create_camera_frame(colorImg,cameraNum,index,goal_centers,goal_radii,showCoordinates,videoOnly, showBBox)
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose:

%% Declare global variables
global bots
global numBots

%% Create the figure for this frame
sfigure(2);
clf;
image(colorImg)  
hold on

%% Parse through the Robots and plot the ones in view
if ~videoOnly
    for i = 1:numBots
        if ((~isempty(bots(i).center)) && (bots(i).cameraNums(index) == cameraNum))
            % Plot the circle around the robot to indicate its position
            viscircles(bots(i).centers(index,:), bots(i).radii(index), 'EdgeColor', bots(i).color);
            
            % If the coordinates are to be displayed
            if showCoordinates
                % Get coordinates for possible display 
                center_mm = [bots(i).Xs(index), bots(i).Ys(index), bots(i).Zs(index)];
                yaw = round(bots(i).yaws(index));
                
                % Create a string of text involving the position
                % information
                str = ['X: ', int2str(center_mm(1,1)), ', Y: ', int2str(center_mm(1,2)), ', Z: ',int2str(center_mm(1,3))];
                str = [str, ', ', num2str(yaw), sprintf('%c', char(176))];
                
                % Display the position text
                text(bots(i).centers(index,1) - 100, bots(i).centers(index,2) - 100, str, 'Color', 'y');
            end
            
            % If the bounding box is to be displayed
            if showBBox
                % Fetch the BBox coordinates
                BBox = bots(i).BBoxes(index,:);
                
                % Display a rectangle using those coordinates
                rectangle('Position', BBox, 'EdgeColor','y', 'LineWidth', 3);
            end
            
            % If there are waypoints within this frame, display those
            if goal_centers ~= 0
                % TODO: Write this section after the overlapping is working
            end
        end
    end
end


%% Output the result
f = getframe;
plotted_frame = f.cdata;

end

