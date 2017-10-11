%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

% Copyright (c) Philipp Wagner. All rights reserved.
% Licensed under the BSD license. See LICENSE file in the project root for full license information.
% load function files from subfolders aswell
clc,clear,close all
%addpath (genpath ('.'));
% load data
path_to_images = 'datasets\gender_l_c_matlab_r150';
img_size = [150,150];
%path_to_images = 'datasets\important_combined';clc
[X y width height names list_images] = read_images(path_to_images);
%load input_data_256
% load X200
% load labels
% number of samples
n = size(X,2);
% get a random index
randomIdx = uint32(rand()*n);
% split data
% into training set
train_ratio = [0.6 0.7 0.8 0.9];%[0.1:0.05:0.95];
number_of_trials = 1;
rate_per_trial = cell(number_of_trials,1);
run_time = zeros(numel(train_ratio),6);
cell_run_time = cell(number_of_trials,1);
for t = 1:number_of_trials    
    idx = randperm(n);   
    rate_k = zeros(numel(train_ratio),13);  
    
    for k = 1 : numel(train_ratio)
        
        ff_train_time = 0;
        ff_test_time = 0;
        pca_train_time = 0;
        pca_test_time = 0;
        hog_train_time = 0;
        hog_test_time = 0;
        
        idx_r = floor(train_ratio(k)*n);
        train_idx = idx(1:idx_r);
        test_idx = idx(idx_r+1:n);
        % Xtrain = X(:, [1:(randomIdx-1), (randomIdx+1):n]);
        % ytrain = y([1:(randomIdx-1), (randomIdx+1):n]);
        Xtrain = X(:, train_idx); 
        ytrain = y(train_idx);
        % into test set
        Xtest = X(:,test_idx); 
        ytest = y(test_idx);
        if((idx_r)<100)
            pca_components = (idx_r);
        else
            pca_components = 100;
        end
        
        % PCA
        tic
        model_pca = eigenfaces(Xtrain,ytrain,pca_components);       
        predicted_pca_k1 = zeros(1, numel(ytest)); 
        predicted_pca_k3 = zeros(1, numel(ytest)); 
        predicted_pca_k5 = zeros(1, numel(ytest)); 
        predicted_pca_k7 = zeros(1, numel(ytest)); 
        predicted_pca_k9 = zeros(1, numel(ytest)); 
        predicted_pca_k11 = zeros(1, numel(ytest)); 
        pca_train_time = pca_train_time + toc;
        
        % compute a model
        tic
        model_ff = fisherfaces(Xtrain,ytrain);
        % get a prediction from the model
        predicted_ff_k3 = zeros(1, numel(ytest));
        ff_train_time = ff_train_time + toc;
        predicted_ff_k5 = zeros(1, numel(ytest));
        predicted_ff_k7 = zeros(1, numel(ytest));
        predicted_ff_k9 = zeros(1, numel(ytest));
        predicted_ff_k11 = zeros(1, numel(ytest));
        predicted_ff_k1 = zeros(1, numel(ytest));
        
        for i = 1:numel(test_idx)
            target = Xtest(: , i);
             tic
            predicted_ff_k3(i) = fisherfaces_predict(model_ff, target, 3);
            ff_test_time = ff_test_time + toc;
            predicted_ff_k1(i) = fisherfaces_predict(model_ff, target, 1);
            predicted_ff_k5(i) = fisherfaces_predict(model_ff, target, 5);
            predicted_ff_k7(i) = fisherfaces_predict(model_ff, target, 7);
            predicted_ff_k9(i) = fisherfaces_predict(model_ff, target, 9);
            predicted_ff_k11(i) = fisherfaces_predict(model_ff, target, 11);
            tic
            predicted_pca_k1(i) = eigenfaces_predict(model_pca, target, 1);
            pca_test_time = pca_test_time + toc;
            predicted_pca_k3(i) = eigenfaces_predict(model_pca, target, 3);
            predicted_pca_k5(i) = eigenfaces_predict(model_pca, target, 5);
            predicted_pca_k7(i) = eigenfaces_predict(model_pca, target, 7);
            predicted_pca_k9(i) = eigenfaces_predict(model_pca, target, 9);
            predicted_pca_k11(i) = eigenfaces_predict(model_pca, target, 11);
        end
        
        
        % only for debug
        %fprintf(1,'predicted=%d,actual=%d\n', predicted, ytest)
       tic
        ff_err_k3=100*(1/numel(test_idx))*sum(predicted_ff_k3 ~=ytest);
        ff_test_time = ff_test_time + toc;
        ff_err_k1=100*(1/numel(test_idx))*sum(predicted_ff_k1 ~=ytest);
        ff_err_k5=100*(1/numel(test_idx))*sum(predicted_ff_k5 ~=ytest);
        ff_err_k7=100*(1/numel(test_idx))*sum(predicted_ff_k7 ~=ytest);
        ff_err_k9=100*(1/numel(test_idx))*sum(predicted_ff_k9 ~=ytest);
        ff_err_k11=100*(1/numel(test_idx))*sum(predicted_ff_k11 ~=ytest);
        tic    
        pca_test_time = pca_test_time + toc;
        pca_err_k1=100*(1/numel(test_idx))*sum(predicted_pca_k1 ~=ytest);
        pca_err_k3=100*(1/numel(test_idx))*sum(predicted_pca_k3 ~=ytest);
        pca_err_k5=100*(1/numel(test_idx))*sum(predicted_pca_k5 ~=ytest);
        pca_err_k7=100*(1/numel(test_idx))*sum(predicted_pca_k7 ~=ytest);
        pca_err_k9=100*(1/numel(test_idx))*sum(predicted_pca_k9 ~=ytest);
        pca_err_k11=100*(1/numel(test_idx))*sum(predicted_pca_k11 ~=ytest);
        
        
        % HOG SVM
        trainData={};
        for ii=1:numel(train_idx)
            trainData{ii} = list_images(train_idx(ii));
        end
        testData={};
        for jj = 1:numel(test_idx)
            testData{jj} = list_images(test_idx(jj));
        end
        [hogsv_err, hogsv_train_time, hogsv_test_time] = hogsvmlearn(trainData,ytrain,testData,ytest, img_size);
%         predictedLabels = zeros(1 , count_test);

%         for i = 1:count_test
%             temp_link = testData{i};
%             queryImage = imread(temp_link{1});
%             queryFeatures = extractHOGFeatures(queryImage, 'CellSize', CellSize, 'NumBins', NumBins, 'BlockSize', BlockSize);
%             predictedLabels(1 , i) = predict(hogsvm_faceClassifier, queryFeatures);
%         end
%         
%        hogsv_err = 100*sum(predictedLabels ~= testLabels)/numel(testLabels);       
        hog_train_time = hog_train_time + hogsv_train_time;
        hog_test_time = hog_test_time + hogsv_test_time;
        % Compute the error
        rate_k(k,1) = ff_err_k1;
        rate_k(k,2) = pca_err_k1;
        rate_k(k,3) = hogsv_err;
        rate_k(k,4) = ff_err_k3;
        rate_k(k,5) = pca_err_k3;
        rate_k(k,6) = ff_err_k5;
        rate_k(k,7) = pca_err_k5;
        rate_k(k,8) = ff_err_k7;
        rate_k(k,9) = pca_err_k7;
        rate_k(k,10) = ff_err_k9;
        rate_k(k,11) = pca_err_k9;
        rate_k(k,12) = ff_err_k11;
        rate_k(k,13) = pca_err_k11;
        fprintf(' Trial no: %02f,  ratio: %02f\n', t, train_ratio(k))
        fprintf(' Taux d''erreur final FF: %02f', ff_err_k3)
        fprintf(' [%d Elements bien classes sur %d]\n',numel(test_idx) - sum(predicted_ff_k3 ~=ytest), numel(test_idx))
        fprintf(' Taux d''erreur final PCA: %02f', pca_err_k1)
        fprintf(' [%d Elements bien classes sur %d]\n',numel(test_idx) - sum(predicted_pca_k1 ~=ytest), numel(test_idx))
        fprintf(' Taux d''erreur final HOGSVM: %02f', hogsv_err)
        fprintf(' [%d Elements bien classes sur %d]\n',(numel(test_idx)*(1 - 0.01*hogsv_err)), numel(test_idx))
        fprintf('*******************************************************************************\n ')
        run_time(k,1) = ff_train_time;
        run_time(k,2) = ff_test_time;
        run_time(k,3) = pca_train_time;
        run_time(k,4) = pca_test_time;
        run_time(k,5) = hog_train_time;   
        run_time(k,6) = hog_test_time;
    end
   
    cell_run_time{t} = run_time;
    rate_per_trial{t} = rate_k;
   
end
boxplot(100 - rate_per_trial)
hold on
plot(mean(100-rate_per_trial))
%plot(100*train_ratio , 100-rate_k)
grid
xlabel('pourcentage')
ylabel('taux de reconnaissance')
