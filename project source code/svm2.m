%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

path_to_images = 'datasets\age_selected_ranges' 
%[X, y, width, height, names, list_images] = read_images(path_to_images);
% number of samples
n = size(X,2);
% split data into training set and test set
train_ratio = [0.1:0.1:0.9];%[0.1:0.05:0.95];

hog_error_rate  =  zeros(1 , numel(train_ratio));
% Random the indexes
idx = randperm(n);
for r = 1 : numel(train_ratio)
    fprintf('try %d, ratio = %02f\n', 1, train_ratio(r));
    %Find the index that split the dataset according to the given
    %ratio
    idx_ratio = floor(train_ratio(r)*n);
    train_idx = idx(1:idx_ratio);
    test_idx = idx(idx_ratio+1:n);
    %Training set
    Xtrain = X(:, train_idx);
    ytrain = y(train_idx);
    %Test set
    Xtest = X(:,test_idx);
    ytest = y(test_idx);  
    %HOG SVM   
    [model_hog , hog_features_train] = hogsvm(list_images , train_idx , ytrain);
    hog_features_test = zeros(numel(ytest), size(hog_features_train,2));
    for i = 1:numel(test_idx)        
       target_hog = list_images(test_idx(i));
       [queryFeatures, output] = hogsvm_predict(model_hog, target_hog); 
       hog_features_test(i,:) = queryFeatures;
    end
end

    g = 0.001;%[0.1 0.05 0.01 0.0075 0.005 0.003 0.001 0.00075 0.0005  0.00035  0.0002 0.0001];
    C = 100;%[1   5    10   30     70    100   200     500    1000    3000     6000   10000];
    optim_params{1} = g;  optim_params{2} = C;

[err_SVM, cm_SVM, svmTestRunningTime, predicted] = Classify_SVM_Test(hog_features_train, ...
                                 ytrain', ...
                                 hog_features_test, ...
                                 ytest', ...
                                 3,... 
                                 optim_params)
