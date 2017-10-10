%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

clear;clc;close all
tic
% Define which section to skip
skip = true;
% Load the train and test data
% Original Data
load train_data
load test_data
[n_samples , n_features] = size(train_features);
n_classes = 10;

% ACP Features
load train_features_acp

% Load ACP projected features
%If needed to recompute the projected ACP for different value of number of components

acpRecompute = true;
if acpRecompute
    n_components = 44;
    % Get the projected data to the 1st n components
    train_features_acp_projected = get_acp_projection(train_features ,...
        train_features_acp.vec_p,...
        train_features_acp.M, ...
        n_components);
    
    test_features_acp_projected  = get_acp_projection(test_features ,...
        train_features_acp.vec_p,...
        mean(test_features), ...
        n_components);
else
    load train_features_acp_projected
    load test_features_acp_projected
end

% Load the random indexes for cross validation
load IndexCrossValidation_k_4;

%%  Beginning of Lab2
if(~skip)
    %% Quadratic Bayes
    disp('Processing Quadratic Bayes...')
    [err_QBayes , cm_QBayes, runtimeQBayes, prediction_QBayes] = Classify_QBayes(train_features_acp_projected, ...
        test_features_acp_projected, ...
        test_labels);
end

if(skip)
    %% K-NN
    % % For Validation Database
    disp('Processing K-NN for the validation database') 
    [err_KNN_Val , cm_KNN_Val, k_optimal, knnValRunningTime, prediction_KNN_Val] = Classify_KNN_Val(train_features_acp_projected, ...
        train_labels, ...
        indexLearning,...
        indexValidation,...
        n_classes);
end

if(~skip)
    %% K-NN
    % % For Test Database 
     disp('Processing K-NN for the test database') 
    [err_KNN_Test , cm_KNN_Test, knnTestRunningTime, prediction_KNN_Test] = Classify_KNN_Test(train_features_acp_projected, ...
        train_labels, ...
        test_features_acp_projected, ...
        test_labels, ...
        n_classes, ...
        k_optimal);
end


if(~skip)
    %% SVM
    % For the validation database
    disp('Processing SVM for the validation database') 
    [err_SVM_Val, cm_SVM_Val, optim_params, svmValRunningTime, prediction_SVM_Val] =...
        Classify_SVM_Val(train_features_acp_projected, ...
                         train_labels, ...
                         indexLearning,...
                         indexValidation,...
                         n_classes);
end

if(~skip)
    % For the test database
    if(~exist('optim_params', 'var'))
        g = 0.001;%[0.1 0.05 0.01 0.0075 0.005 0.003 0.001 0.00075 0.0005  0.00035  0.0002 0.0001];
        C = 100;  %[1   5    10   30     70    100   200     500    1000    3000     6000   10000];
        optim_params{1} = g;  optim_params{2} = C;
    end 
    disp('Processing SVM for the test database') 
    [err_SVM_Test, cm_SVM_Test, svmTestRunningTime, prediction_SVM_Test] = Classify_SVM_Test(train_features_acp_projected, ...
        train_labels, ...
        test_features_acp_projected, ...
        test_labels, ...
        n_classes, optim_params);
end
GlobalTime = toc;
save Lab2Results2