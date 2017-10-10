%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Download the MNIST data from: http://yann.lecun.com/exdb/mnist/

var_vect = [0.001 0.01 0.05 0.08 0.1 0.15 0.2 0.3 0.4 0.5 0.7 1];
error_per_n_comp = zeros(numel(var_vect), 5);
t_per_n_comp = zeros(numel(var_vect), 6);
optim_params_per_n_comp = zeros(numel(var_vect), 3); 
for v = 1:numel(var_vect)
    noise_variance = var_vect(v)
%% Lab1
% Computing the features vectors for the train and test databases
%if ~exist('train_data.mat', 'file') == 2
    [train_features , train_labels] = get_features(1, noise_variance);
% else load train_data
% end
% if ~exist('test_data.mat', 'file') == 2
    [test_features , test_labels] = get_features(2, noise_variance);
% else load test_data
% end

% Compute the Overlap
overlap_rate_train(v) = overlap_v3(train_features',train_labels);
overlap_rate_test(v) = overlap_v3(test_features',test_labels);

% Dimensionality reduction with ACP
% n_components : number of principal components to keep 
% Compute the Principal Components 
train_features_acp = get_acp_components(train_features);

% save train_features_acp train_features_acp

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

% Define which section to skip
skip = false;
% Load the train and test data
% Original Data
% load train_data
% load test_data
[n_samples , n_features] = size(train_features);
n_classes = 10;
% ACP Features
% load train_features_acp
% Load ACP projected features
%If needed to recompute the projected ACP for different value of number of components
% acpRecompute = false;
% n_comp_vect = 44;%1:98;% [5 10 18 25 30 33 37 39 44 50 60 65 70 80 90 98];
% n_comp_result = zeros(numel(n_comp_vect) , 2);
% Load the random indexes for cross validation
load IndexCrossValidation_k_4;
% for nc = 1:numel(n_comp_vect)
%     n_components = n_comp_vect(nc);
%     if acpRecompute
%         do_acp_recompute;
%     else
%         load train_features_acp_projected
%         load test_features_acp_projected
%     end    
%     
    if(~skip)   qbayes_demo;   end
    if(~skip)   knn_val_demo;  end
    if(~skip)   knn_test_demo;  end
    if(skip)    svm_val_demo;  end
    if(skip)    svm_test_demo;  end
    if(~skip)   libsvm_val_demo;  end
    if(~skip)   libsvm_test_demo;  end
    
   compute_stats_var; 
end   
     n_comp_result(nc,1) = k_optimal;
%     n_comp_result(nc,2) = 100*err_KNN_Val;
% end
% GlobalTime = toc;
% save Lab2Results2                           
%                             
                            
                            
                            
                            