%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

%% K-NN
    % % For Validation Database
    disp('Processing K-NN for the validation database') 
    [err_KNN_Val , cm_KNN_Val, k_optimal, knnValRunningTime, prediction_KNN_Val] = Classify_KNN_Val(train_features_acp_projected, ...
        train_labels, ...
        indexLearning,...
        indexValidation,...
        n_classes);