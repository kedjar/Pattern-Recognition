%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

function [err_SVM, cm_SVM, optim_params, svmValRunningTimeFinal, prediction_SVM_Val] =...
                Classify_LIBSVM_Val(trainData, ...
                                 trainLabels, ...       
                                 nClasses)
tic 
nSamples = numel(trainLabels);

% nSamplesPerVal = floor(0.20*nSamples);
% learningIndex =  transpose((nSamplesPerVal+1:nSamples));
% validationIndex = transpose((1:nSamplesPerVal));

nSamplesPerVal = floor(0.20*nSamples);
learningIndex =  zeros(nSamples - nSamplesPerVal,5);
validationIndex = zeros(nSamplesPerVal,5);

learningIndex(:,1) = [164:815]';        validationIndex(:,1) = [1:163]'; 
learningIndex(:,2) = [1:163 327:815]';  validationIndex(:,2) = [164:326]'; 
learningIndex(:,3) = [1:326 490:815]';  validationIndex(:,3) = [327:489]'; 
learningIndex(:,4) = [1:489 653:815]';  validationIndex(:,4) = [490:652]'; 
learningIndex(:,2) = [1:652]';          validationIndex(:,5) = [653:815]'; 

doCrossValidation = true;
if doCrossValidation
    nCrossValidation = size(validationIndex , 2);
else
    nCrossValidation = 1; %#ok<UNRCH>
end
g_e = -4:-1;
C_e = 0:4;
g = 10.^(g_e);
C = 10.^(C_e);
e = 0.0001;
k = 1;
prediction_SVM_Val = cell(numel(g) , numel(C), nCrossValidation); 
valClassificationError_mtx = zeros(numel(g) , numel(C), nCrossValidation);
learningTimePerClass = zeros(numel(g) , numel(C), nClasses);
validationTimePerClass = zeros(numel(g) , numel(C), nClasses);
validationTimePerSvmConfig = zeros(numel(g) , numel(C));
svmValRunningTime = cell(3,nCrossValidation);
svmValRunningTimeFinal = struct;
validationTimeSavingFirstStep = toc;
svmValRunningTimeFinal.validationTimeSavingFirstStep = validationTimeSavingFirstStep;
for ncv = 1:nCrossValidation
    learningData = trainData(learningIndex(: , ncv), :);  % Learning data set
    learningLabels = trainLabels(learningIndex(: , ncv));
    validationData = trainData(validationIndex(: , ncv), :);% Validation data set
    validationLabels = trainLabels(validationIndex(: , ncv));  % Validation labels 
    valOneVsAllLabels = ones(size(learningLabels)); % TO contains the labels in the 1 against all strategy       
    predictedLabels_mtx = zeros(numel(validationLabels) , nClasses);   
    for i = 1:numel(g)        
        for j = 1:numel(C)            
            for classNumber = 1:nClasses
%%%%%%%%%%%%%%%% % Begin Learning for class classNumber vs all
                tic 
                disp(strcat('g = ', num2str(g(i)), ' C = ', num2str(C(j)), ' Class =' , num2str(classNumber)))
                indexMinus = learningLabels ~= classNumber;  
                indexPlus = learningLabels == classNumber;                    
                valOneVsAllLabels(indexMinus) = -1;    
                valOneVsAllLabels(indexPlus)  =  1;  
                svmLearningParams = ['-t 2 -g ' num2str(g(i)) ' -c ' num2str(C(j)) ' -e ' num2str(e(k))] ;
                % Train the model                
                svmLearningModel = svmtrain(valOneVsAllLabels, learningData, svmLearningParams);
                learningTimePerClass(i , j, classNumber) = toc;
%%%%%%%%%%%%%%%% % End Learning  for class classNumber vs all
%%%%%%%%%%%%%%%% % Begin Testing for class classNumber vs all
                tic
                % Test the model
                [svmPredictedLabels, ~, ~] = svmpredict(validationLabels, validationData, svmLearningModel); 
                %[~,svmPredictedLabels] = mexsvmclassify(validationData, validationLabels, svmLearningModel);  
                predictedLabels_mtx(: , classNumber) = svmPredictedLabels;
                validationTimePerClass(i , j, classNumber) = toc;
%%%%%%%%%%%%%%%% % End Testing for class classNumber vs all
            end
%%%%%%%%%%%%%%%% % Begin Testing for all classes
            tic
            [~ , predicted] =  max(predictedLabels_mtx,[],2);
            prediction_SVM_Val{i, j, ncv} = predicted;
            valClassificationError_mtx(i , j, ncv) = sum(predicted ~= validationLabels);
            validationTimePerSvmConfig(i , j) = toc;
%%%%%%%%%%%%%%%% % End Testing for all classes            
        end
    end
  svmValRunningTime{1, ncv} = learningTimePerClass; 
  svmValRunningTime{2, ncv} = validationTimePerClass; 
  svmValRunningTime{3, ncv} = validationTimePerSvmConfig;
end
tic
cm_SVM=0;
err_SVM = valClassificationError_mtx;
[optim_err, optim_row] = min(min(err_SVM, [], 1));
[~, optim_column] = min(min(err_SVM, [], 2));
optim_params{1} = g(optim_row);%0.001;
optim_params{2} = C(optim_column);%100;
svmValRunningTimeFinal.learningTimePerClass =  svmValRunningTime{1, :};
svmValRunningTimeFinal.validationTimePerClass =  svmValRunningTime{2, :};
svmValRunningTimeFinal.validationTimePerSvmConfig = validationTimePerSvmConfig;
validationTimeSavingLastStep = toc;
svmValRunningTimeFinal.validationTimeSavingLastStep = validationTimeSavingLastStep;
err_SVM = optim_err/(length(validationLabels));
save libsvmValResults
end