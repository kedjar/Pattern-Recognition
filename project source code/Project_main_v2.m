%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

clear,clc,close all
load('datasets/sys800/foldfrontaldata.mat')
load('datasets/sys800/list_of_images.mat')

targetNames = cell(size(foldfrontal0data , 1),1);
sourceNames  = cell(size(list_of_images , 1),2);
for i = 1:size(foldfrontal0data , 1)
    target = foldfrontal0data{i,2};
    target_splt = strsplit(target,'.');
    targetNames{i,1} = target_splt{1};
end

for j = 1:size(list_of_images , 1)
    source = list_of_images{j,2};
    source_splt = strsplit(source,'.');
    %soursize(list_of_images , 1)ceNames{1,i} = source_splt{1};
    sourceNames{j,1} = str2double(source_splt{end-2});
    sourceNames{j,2} = strcat(source_splt{end-1},'.',source_splt{end});
end
% source_splt = strsplit(source,'.');
% target_splt = strsplit(target,'.');

i = 6;
file_name = strcat('landmark_aligned_face','.',num2str(foldfrontal0data{i,3}),'.',foldfrontal0data{i,2});
image_path = strcat('datasets/sys800/aligned/', foldfrontal0data{i,1}, '/', file_name);
imshow(imread(image_path))


