%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

function [hogFeatures] = hog_features(model_hog, target)
%img_size = model_hog.img_size;
CellSize = model_hog.CellSize;
BlockSize = model_hog.BlockSize;
%BlockOverlap = model_hog.BlockOverlap;
NumBins = model_hog.NumBins;
%BlocksPerImage = model_hog.BlocksPerImage;
queryImage = imread(target{1});
hogFeatures = extractHOGFeatures(queryImage, 'CellSize', CellSize, 'NumBins', NumBins, 'BlockSize', BlockSize);
end