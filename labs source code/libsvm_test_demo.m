%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

 % For the test database
    if(~exist('optim_params', 'var'))
        g = 0.001;%[0.1 0.05 0.01 0.0075 0.005 0.003 0.001 0.00075 0.0005  0.00035  0.0002 0.0001];
        C = 100;  %[1   5    10   30     70    100   200     500    1000    3000     6000   10000];
        optim_params{1} = g;  optim_params{2} = C;
    end 
    disp('Processing LIBSVM for the test database') 
    [err_LIBSVM_Test, cm_LIBSVM_Test, libsvmTestRunningTime, prediction_LIBSVM_Test] = Classify_LIBSVM_Test(train_features_acp_projected, ...
        train_labels, ...
        test_features_acp_projected, ...
        test_labels, ...
        n_classes, optim_params);