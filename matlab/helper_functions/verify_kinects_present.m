function [ found, kinectTags ] = verify_kinects_present( kinectID_list )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global numKinects

found = false;
numFound = 0;
kinectTags = strings(1,numKinects);
topics = rostopic('list')';
splitList = strsplit(kinectID_list, ',');
for i = 1:numKinects
    kinectInfo = strsplit(splitList(i),':');
    kinectTags(i) = strcat('/', 'kinect', kinectInfo(1),'/');
    TF = contains(topics,kinectTags(i));
    if sum(TF) == 2
       numFound = numFound + 1;
    else
        fprintf('Missing %s\n',kinectTags(i));
    end
end

if numFound == numKinects
    found = true;
end

end