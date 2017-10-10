%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

%%  Beginning of Lab2

    %% Quadratic Bayes
    disp('Processing Quadratic Bayes...')
    [err_QBayes , cm_QBayes, runtimeQBayes, prediction_QBayes] = Classify_QBayes(train_features_acp_projected, ...
        test_features_acp_projected, ...
        test_labels);
