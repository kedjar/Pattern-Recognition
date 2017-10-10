%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
function [err_SVM, cm_SVM, svmTestRunningTime, prediction_SVM_Test] = Classify_SVM_Test(trainData, ...
                                 trainLabels, ...
                                 testData, ...
                                 testLabels, ...
                                 nClasses,... 
                                 optim_params)
tic 
if(~exist('optim_params', 'var'))
    g = [0.1 0.05 0.01 0.0075 0.005 0.003 0.001 0.00075 0.0005  0.00035  0.0002 0.0001];
    C = [1   5    10   30     70    100   200     500    1000    3000     6000   10000];
    optim_params{1} = g;  optim_params{2} = C;
end 
g = optim_params{1};
C = optim_params{2};
%Tx = trainData;  
testOneVsAllLabels = ones(size(trainLabels));    
%Vx = testData;
%Vy = testLabels;
predictedLabels_mtx = zeros(numel(testLabels) , nClasses);
error_mtx = zeros(numel(g) , numel(C));
prediction_SVM_Test = cell(numel(g) , numel(C)); 
trainTime = zeros(numel(g) , numel(C), nClasses);
testTime = zeros(numel(g) , numel(C), nClasses);
svmTestRunningTime = cell(3,1);

for i = 1:numel(g)       
    for j = 1:numel(C)       
        for classNumber = 1:nClasses
            tic
            indexMinus = trainLabels ~= classNumber;
            indexPlus  = trainLabels == classNumber;           
            testOneVsAllLabels(indexMinus) = -1;
            testOneVsAllLabels(indexPlus)  = 1;                        
            svmLearningParams = ['-t 2 -g ' num2str(g(i)) ' -c ' num2str(C(j)) ' -j ' num2str(C(j))] ;
            % Train the model
            svmLearningModel = mexsvmlearn(trainData, testOneVsAllLabels, svmLearningParams); % Tx and Yx are the training data and their labels             
            trainTime(i , j, classNumber) = toc;
            tic
            % Test the model
            [~,svmPredictedLabels] = mexsvmclassify(testData, testLabels,svmLearningModel);  % Vx and Vy are the validation samples and their labels
            predictedLabels_mtx(: , classNumber) = svmPredictedLabels;
            testTime(i , j, classNumber) = toc;
        end
        [~ , predicted] =  max(predictedLabels_mtx, [], 2);  
        prediction_SVM_Test{i, j} = predicted;
        error_mtx(i , j) = sum(predicted ~= testLabels); 
        
    end
end
svmTestRunningTime{1, 1} = trainTime; 
svmTestRunningTime{2, 1} = testTime;
err_SVM =error_mtx;
cm_SVM=c_matrix(nClasses , predicted); 
svmTestRunningTimeAll = toc;
svmTestRunningTime{3, 1} = svmTestRunningTimeAll;
save svmTestResults
end                            
