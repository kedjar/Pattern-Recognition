%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

function [model_hog , features_train] = hogsvm(list_images , train_idx , trainLabels)
% Getting the train data files 
trainData=cell(1,numel(train_idx));
for ii=1:numel(train_idx)
    trainData{ii} = list_images(train_idx(ii));
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

count_train = numel(trainLabels);
features_train = zeros(count_train,HOG_feature_length);

for i = 1:count_train
    temp_link = trainData{i};
    img = imread(temp_link{1});
    features_train(i, :) = extractHOGFeatures(img, 'CellSize', CellSize, 'NumBins', NumBins, 'BlockSize', BlockSize);
end
hogsvm_faceClassifier = fitcecoc(features_train,trainLabels);
model_hog.model = hogsvm_faceClassifier;
model_hog.img_size = img_size;
model_hog.CellSize = CellSize;
model_hog.BlockSize = BlockSize;
model_hog.BlockOverlap = BlockOverlap;
model_hog.NumBins = NumBins;
model_hog.BlocksPerImage = BlocksPerImage;
end

