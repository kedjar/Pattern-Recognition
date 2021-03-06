%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

%% SVM
% For the validation database
disp('Processing LIBSVM for the validation database')
[err_LIBSVM_Val, cm_LIBSVM_Val, libsvm_optim_params,...
    libsvmValRunningTime, prediction_LIBSVM_Val] =...
    Classify_LIBSVM_Val(hog_trainData_2, ...
    trainLabels_2, ...
    2);