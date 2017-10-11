%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

%clc,clear,close all
% load data
%path_to_images = 'datasets\gender_l_c_matlab_r500';
%path_to_images = 'datasets\important_combined';
path_to_images = 'datasets\age_selected_ranges' 
%img_size = [150,150];

%[X, y, width, height, names, list_images] = read_images(path_to_images);
% number of samples
n = size(X,2);
% split data into training set and test set
train_ratio = [0.1:0.1:0.9];%[0.1:0.05:0.95];
test_vector_length = zeros(1, numel(train_ratio));
knn_vector = 1;%[1 3 5 7 9 11];
% To compute the runtime of each algorithm
ff_train_time   =  zeros(1 , numel(train_ratio));
ff_test_time    =  zeros(numel(knn_vector) , numel(train_ratio));
pca_train_time  =  zeros(1 , numel(train_ratio));
pca_test_time   =  zeros(numel(knn_vector) , numel(train_ratio));
hog_train_time  =  zeros(1 , numel(train_ratio));
hog_test_time   =  zeros(1 , numel(train_ratio));
% To compute the error rate of each algorithm
ff_error_rate   =  zeros(numel(knn_vector) , numel(train_ratio));
pca_error_rate  =  zeros(numel(knn_vector) , numel(train_ratio));
hog_error_rate  =  zeros(1 , numel(train_ratio));
ff_hog_error_rate = zeros(numel(knn_vector) , numel(train_ratio));
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
    %Select the  number of components for PCA
    if((idx_ratio)<100)
        pca_components = (idx_ratio);
    else
        pca_components = 100;
    end
    
    %compute a model
    %PCA    
    model_pca = eigenfaces(Xtrain, ytrain, pca_components);   
    %FF   
    model_ff = fisherfaces(Xtrain,ytrain);    
    %HOG SVM   
    [model_hog , hog_features_train] = hogsvm(list_images , train_idx , ytrain);
    %FF HOG
    model_ff_hog = fisherfaces(hog_features_train',ytrain);
        
    %get a prediction from the model
    predicted_pca = zeros(1 , numel(ytest));
    predicted_ff = zeros(1 , numel(ytest));
    predicted_hog = zeros(1 , numel(ytest));
    predicted_ff_hog = zeros(1 , numel(ytest));
    for i = 1:numel(test_idx)
        target_ff_pca = Xtest(: , i);
        target_hog = list_images(test_idx(i));
        predicted_ff(1, i) =  fisherfaces_predict(model_ff, target_ff_pca, 1);
        predicted_pca(1, i) =  eigenfaces_predict(model_pca, target_ff_pca, 1);        
        [queryFeatures, output] = hogsvm_predict(model_hog, target_hog);
        predicted_hog(i) = output;
        predicted_ff_hog(i) = fisherfaces_predict(model_ff_hog, queryFeatures', 1);      
    end

    %Compute the error rate

        ff_error_rate(1,r) = (100/numel(ytest))*sum(predicted_ff(1, :) ~=ytest);
        pca_error_rate(1,r) = (100/numel(ytest))*sum(predicted_pca(1, :) ~=ytest);
        hog_error_rate(1,r) = (100/numel(ytest))*sum(predicted_hog ~=ytest);
        ff_hog_error_rate(1,r)  = (100/numel(ytest))*sum(predicted_ff_hog ~=ytest);
end

disp('done!')
boxplot(100 - rate_per_trial)
hold on
plot(mean(100-rate_per_trial))
%plot(100*train_ratio , 100-rate_k)
grid
xlabel('pourcentage')
ylabel('taux de reconnaissance')
