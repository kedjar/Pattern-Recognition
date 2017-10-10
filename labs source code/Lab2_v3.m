%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

clear
clc
close all

load train_data
load test_data
load train_features_acp

skip = true;

[n_samples , n_features] = size(train_features);
n_classes = 10;
rate_reduce = 0.10;
rate_split  = 0.75;

% Random data selection and data reduction
indl = 1:size(train_features, 1);
indt = 1:size(test_features, 1);
% Random data selection ( using the rate_split value)
%[ind1 , ind2]   = index_split(n_samples , n_classes , rate_split);
[ind1 , ind2]   = index_split_cv(train_labels, n_samples , n_classes , rate_split);
if(~skip)
    % Reduce the data (using the rate_reduce value
    [indr1 , indr2] = index_reduce(ind1 , ind2, n_classes , rate_reduce);
    k_optimal = 1;
end
n_components = 44;
% Get the projected data to the 1st n components
  = get_acp_projection(train_features ,...
    train_features_acp.vec_p,...
    train_features_acp.M, ...
    n_components);

test_features_acp_projected  = get_acp_projection(test_features ,...
    train_features_acp.vec_p,...
    mean(test_features), ...
    n_components);



%%  Beginning of Lab2
if(~skip)
%% Quadratic Bayes
tic
[err_QBayes , cm_QBayes] = Classify_QBayes(train_features_acp_projected, ...
    test_features_acp_projected, ...
    test_labels, ...
    n_components);
end
if(~skip)
%% K-NN
% % For Test Database
[err_KNN_t, cm_KNN_t, err_t] = Classify_KNN(...
    train_features_acp_projected(ind_l, :), ...
    train_labels(ind_l, :), ind_l, ...
    test_features_acp_projected(ind_t, :), ...
    test_labels(ind_t), ind_t, ...
    n_classes, k_optimal);
end

%%SVM
% For the validation database
if(~skip)
save svm_data_11_19_2016
[err_SVM, cm_SVM, err_v] = Classify_SVM(...
        train_features_acp_projected(ind1, :), ...
        train_labels(ind1), ind1, ...
        train_features_acp_projected(ind2, :), ...
        train_labels(ind2), ind2, ...
        n_classes);
end
% For the test database
save svm_data_11_19_2016
[err_SVM, cm_SVM, err_v] = Classify_SVM(...
        train_features_acp_projected(indl, :), ...
        train_labels(indl), indl, ...
        test_features_acp_projected(indt, :), ...
        test_labels(indt), indt, ...
        n_classes);