%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

clear all, clc, close all
% Set the path for the training and test sets
% The train dataset contains 3938 pictures of class 1 and 4151 of class 2
% The test dataset contains 854 of class 1, and 907 of class 2
train_path = 'datasets\important\gender\learn'; 
test_path = 'datasets\important\gender\test';
train_images = imageSet(train_path, 'recursive');
test_images = imageSet(test_path, 'recursive');
% Define the number of samples to take from each dataset. 
N_train = 400; % 600 for each class
N_test = 100;  % 150 for each class

trainData = cell(1 , N_train);
trainLabels = zeros(1 , N_train);
count_train = 0;
testData = cell(1 , N_test);
testLabels = zeros(1 , N_test);
count_test = 0;

% Randomnly select the images
for i = 1:numel(train_images)
    ind_rand = randperm(train_images(i).Count);
    ind_train = ind_rand(1:N_train / numel(train_images));
    for j = 1:numel(ind_train)
        count_train = count_train + 1;
        trainData{count_train} = train_images(i).ImageLocation{ind_train(i)};
        trainLabels(count_train) = str2double(train_images(i).Description); 
    end
    
    ind_rand = randperm(test_images(i).Count);
    ind_test = ind_rand(1:N_test / numel(test_images));
    for k = 1:numel(ind_test)   
        count_test = count_test + 1;
        testData{count_test} = test_images(i).ImageLocation{ind_test(k)};
        testLabels(count_test) = str2double(test_images(i).Description); 
    end
    
end

% Choosing HOG parameters
img_size = [256,256];
CellSize = [32 32];
BlockSize = [2 2];
BlockOverlap = ceil(BlockSize/2);
NumBins = 18;
BlocksPerImage = floor((img_size./CellSize - BlockSize)./(BlockSize - BlockOverlap) + 1);
HOG_feature_length = prod([BlocksPerImage, BlockSize, NumBins]);
features_train = zeros(count_train,HOG_feature_length);

for i = 1:count_train
    img = imread(trainData{i});
    features_train(i, :) = extractHOGFeatures(img, 'CellSize', CellSize, 'NumBins', NumBins, 'BlockSize', BlockSize);
end

hogsvm_faceClassifier = fitcecoc(features_train,trainLabels);
predictedLabels = zeros(1 , count_test);

for i = 1:count_test               
        queryImage = imread(testData{i});        
        queryFeatures = extractHOGFeatures(queryImage, 'CellSize', CellSize, 'NumBins', NumBins, 'BlockSize', BlockSize);
        predictedLabels(1 , i) = predict(hogsvm_faceClassifier, queryFeatures);       
end

hogsv_err = 100*sum(predictedLabels ~= testLabels)/numel(testLabels)