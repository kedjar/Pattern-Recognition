%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

function [hog_parameters, hog_features] = get_hog_features(list_images)

% Getting the train data files 
trainData=cell(1,numel(list_images));
for i=1:numel(list_images)
    trainData{i} = list_images(i);
end
% Getting the image size
temp_link = trainData{1};
temp_img = imread(temp_link{1}); 
img_size(1,1) = size(temp_img ,1);
img_size(1,2) = size(temp_img ,2);
% Setting the HOG Parameters
CellSize = [32 32];
BlockSize = [2 2];
BlockOverlap = ceil(BlockSize/2);
NumBins = 18;
BlocksPerImage = floor((img_size./CellSize - BlockSize)./(BlockSize - BlockOverlap) + 1);
HOG_feature_length = prod([BlocksPerImage, BlockSize, NumBins]);

count_train = numel(list_images);
hog_features = zeros(count_train,HOG_feature_length);

for i = 1:count_train
    temp_link = trainData{i};
    img = imread(temp_link{1});
    hog_features(i, :) = extractHOGFeatures(img, 'CellSize', CellSize, 'NumBins', NumBins, 'BlockSize', BlockSize);
end
hog_parameters.img_size = img_size;
hog_parameters.CellSize = CellSize;
hog_parameters.BlockSize = BlockSize;
hog_parameters.BlockOverlap = BlockOverlap;
hog_parameters.NumBins = NumBins;
hog_parameters.BlocksPerImage = BlocksPerImage;
end