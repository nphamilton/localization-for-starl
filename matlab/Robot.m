classdef Robot
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose:
    
    properties
        center
        radius
        radii = [];
        X
        Xs = [];
        Y
        Ys  = [];
        Z
        Zs = [];
        yaw
        yaws = [];
        depth
        BBox
        BBoxes = [];
        BBoxTight % BBox with BBox factor of 1
        color
        type
        name
        kinectNum
        kinectNums = [];
        hyst
    end
    
    methods
    end
    
end

