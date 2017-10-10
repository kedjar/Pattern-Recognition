%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

% Compute the error for the given value of n_components

error_per_n_comp(v,1) = err_QBayes;
error_per_n_comp(v,2) = err_KNN_Val;
error_per_n_comp(v,3) = err_KNN_Test;
error_per_n_comp(v,4) = err_LIBSVM_Val;
error_per_n_comp(v,5) = err_LIBSVM_Test;

% Compute the time for the given value of n_components

% Learning phase
t_per_n_comp(v,1) = runtimeQBayes(1);
t_per_n_comp(v,2) = knnValRunningTime.t1...
                         + knnValRunningTime.t2...
                         + knnValRunningTime.t3...
                         + knnValRunningTime.t4;
t_per_n_comp(v,3) = compute_time_libsvm_val(libsvmValRunningTime);
% Test phase
t_per_n_comp(v,4) = runtimeQBayes(2);
t_per_n_comp(v,5) = knnTestRunningTime;
t_per_n_comp(v,6) = compute_time_libsvm_test(libsvmTestRunningTime);

% Compute the optimal parameters for the given value of n_components

% knn
optim_params_per_n_comp(v, 1) = k_optimal;
% svm
optim_params_per_n_comp(v, 2) = optim_params{1};
optim_params_per_n_comp(v, 3) = optim_params{2};
