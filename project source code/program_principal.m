%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

clc,clear,close all
% load data
%path_to_images = 'datasets\gender_l_c_matlab_r150';
img_size = [150,150];
path_to_images = 'datasets\important_combined';
[X, y, width, height, names, list_images] = read_images(path_to_images);
% number of samples
n = size(X,2);
% split data into training set and test set
train_ratio = 0.7;%[0.1:0.05:0.95];
test_vector_length = zeros(1, numel(train_ratio));
knn_vector = 1;%[1 3 5 7 9 11];
number_of_trials = 1;
cell_error_rate_per_trial = cell(number_of_trials,3);
run_time = zeros(numel(train_ratio),6);
cell_run_time_per_trial = cell(number_of_trials,6);


for t = 1:number_of_trials    
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
    % Random the indexes
    idx = randperm(n);
    
    %rate_k = zeros(numel(train_ratio),13);  
    
    for r = 1 : numel(train_ratio)
        fprintf('try %d, ratio = %02f\n', t, train_ratio(r));
        % Find the index that split the dataset according to the given
        % ratio
        idx_ratio = floor(train_ratio(r)*n);
        train_idx = idx(1:idx_ratio);
        test_idx = idx(idx_ratio+1:n);  
        % Training set
        Xtrain = X(:, train_idx); 
        ytrain = y(train_idx);
        % Test set
        Xtest = X(:,test_idx); 
        ytest = y(test_idx);
        % Select the  number of components for PCA
        if((idx_ratio)<100)
            pca_components = (idx_ratio);
        else
            pca_components = 100;
        end
        
        % compute a model
        % PCA
        tic
        model_pca = eigenfaces(Xtrain, ytrain, pca_components); 
        pca_train_time(1, r) = toc;       
        % FF
        tic
        model_ff = fisherfaces(Xtrain,ytrain);            
        ff_train_time(1, r) = toc;
        % HOG SVM
        tic
        [model_hog , features_train] = hogsvm(list_images , train_idx , ytrain);
        hog_train_time(1, r) = toc;
        
        % get a prediction from the model  
        predicted_pca = zeros(numel(knn_vector) , numel(ytest));
        predicted_ff = zeros(numel(knn_vector) , numel(ytest)); 
        predicted_hog = zeros(1 , numel(ytest)); 
        for i = 1:numel(test_idx)
            target = Xtest(: , i);
            for k = 1:numel(knn_vector)
                n_neighbors = knn_vector(k);
                tic
                predicted_ff(k, i) =  fisherfaces_predict(model_ff, target, n_neighbors);
                ff_test_time(k , r) = ff_test_time(k , r) + toc;
                
                tic
                predicted_pca(k, i) =  eigenfaces_predict(model_pca, target, n_neighbors);
                pca_test_time(k , r) = pca_test_time(k , r) + toc;
            end
        end
        tic        
        for i = 1:numel(test_idx)
            target = list_images(test_idx(i));
            predicted_hog(i) = hogsvm_predict(model_hog, target);
        end
        hog_test_time(r) = hog_test_time(r) + toc;      
        
        % Compute the error rate
        for k = 1:numel(knn_vector)
            tic
            ff_error_rate(k , r) = sum(predicted_ff(k, :) ~=ytest);
            ff_test_time(k , r) = ff_test_time(k , r) + toc;
            tic
            pca_error_rate(k , r) = sum(predicted_pca(k, :) ~=ytest);
            pca_test_time(k , r) = pca_test_time(k , r) + toc;
        end
        tic
        hog_error_rate(1,r) = sum(predicted_hog ~=ytest);
        hog_test_time(r) = hog_test_time(r) + toc; 
        test_vector_length(1,r) = numel(test_idx);
    end   
    cell_error_rate_per_trial{t,1} = ff_error_rate;
    cell_error_rate_per_trial{t,2} = pca_error_rate;
    cell_error_rate_per_trial{t,3} = hog_error_rate;
    
    cell_run_time_per_trial{t,1} = ff_train_time;
    cell_run_time_per_trial{t,2} = pca_train_time;
    cell_run_time_per_trial{t,3} = hog_train_time;
    cell_run_time_per_trial{t,4} = ff_test_time;
    cell_run_time_per_trial{t,5} = pca_test_time;
    cell_run_time_per_trial{t,6} = hog_test_time;
    
end
disp('done!')
% boxplot(100 - rate_per_trial)
% hold on
% plot(mean(100-rate_per_trial))
% %plot(100*train_ratio , 100-rate_k)
% grid
% xlabel('pourcentage')
% ylabel('taux de reconnaissance')
