%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

% Choosing HOG parameters
function [hogsv_err, hogsv_train_time, hogsv_test_time] = hogsvmlearn(trainData,trainLabels,testData,testLabels, img_size)
%img_size = [300,300];
tic
CellSize = [32 32];
BlockSize = [2 2];
BlockOverlap = ceil(BlockSize/2);
NumBins = 18;
BlocksPerImage = floor((img_size./CellSize - BlockSize)./(BlockSize - BlockOverlap) + 1);
HOG_feature_length = prod([BlocksPerImage, BlockSize, NumBins]);
count_train = numel(trainLabels);
count_test = numel(testLabels);
features_train = zeros(count_train,HOG_feature_length);

for i = 1:count_train
    temp_link = trainData{i};
    img = imread(temp_link{1});
    features_train(i, :) = extractHOGFeatures(img, 'CellSize', CellSize, 'NumBins', NumBins, 'BlockSize', BlockSize);
end

hogsvm_faceClassifier = fitcecoc(features_train,trainLabels);
hogsv_train_time = toc;
tic
predictedLabels = zeros(1 , count_test);

for i = 1:count_test 
        temp_link = testData{i};
        queryImage = imread(temp_link{1});        
        queryFeatures = extractHOGFeatures(queryImage, 'CellSize', CellSize, 'NumBins', NumBins, 'BlockSize', BlockSize);
        predictedLabels(1 , i) = predict(hogsvm_faceClassifier, queryFeatures);       
end

hogsv_err = 100*sum(predictedLabels ~= testLabels)/numel(testLabels);
hogsv_test_time = toc;
end