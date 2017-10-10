%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

clear;clc;close all
tic
% Define which section to skip
skip = false;
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
acpRecompute = false;
n_comp_vect = 44;%1:98;% [5 10 18 25 30 33 37 39 44 50 60 65 70 80 90 98];
n_comp_result = zeros(numel(n_comp_vect) , 2);
% Load the random indexes for cross validation
load IndexCrossValidation_k_4;
for nc = 1:numel(n_comp_vect)
    n_components = n_comp_vect(nc);
    if acpRecompute
        do_acp_recompute;
    else
        load train_features_acp_projected
        load test_features_acp_projected
    end    
    
    if(~skip)   qbayes_demo;   end
    if(~skip)   knn_val_demo;  end
    if(~skip)   knn_test_demo;  end
    if(skip)    svm_val_demo;  end
    if(skip)    svm_test_demo;  end
    if(~skip)   libsvm_val_demo;  end
    if(~skip)   libsvm_test_demo;  end
    n_comp_result(nc,1) = k_optimal;
    n_comp_result(nc,2) = 100*err_KNN_Val;
end
GlobalTime = toc;
save Lab2Results2