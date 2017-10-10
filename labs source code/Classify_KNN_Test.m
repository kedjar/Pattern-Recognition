%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
function [err_KNN , cm_KNN, knnTestRunningTime, prediction_KNN_Test] = Classify_KNN_Test(trainData, ...
                                  trainLabels, ...
                                  testData, ...
                                  testLabels, ...
                                  nClasses, k_optimal)
tic   
if(~exist('k_optimal', 'var'))
    k_optimal = 1;
end
% trainData and trainLabels: data for learning
% testData and testLabels: data for validation
prediction_KNN_Test = zeros(numel(testLabels) ,  numel(k_optimal)); % predicted labels
cm = cell(1 , numel(k_optimal));
d = zeros(numel(testLabels) , numel(trainLabels));

for i = 1 : numel(testLabels)
    xi = repmat(testData(i , :), numel(trainLabels), 1); % the sample i 
    d(i , :) = sum((xi - trainData).^2 , 2);       
end

for i = 1 : numel(testLabels)
 [~ , ind] = sort(d(i , :), 'ascend');
    for j = 1 : numel(k_optimal);
        n_neighbors = k_optimal(j);
        [~ , maxindex] = max_index(trainLabels(ind(1 : n_neighbors)));
        prediction_KNN_Test(i , j) = maxindex;
    end
end

% Compute the confusion matrix
for j = 1 : numel(k_optimal)
    cm{j} = confusionmat(testLabels, prediction_KNN_Test(: , j));
end
% Compute the error matrix
err = sum(prediction_KNN_Test ~= repmat(testLabels,1,length(k_optimal)) , 1) / (length(testLabels));
% compute the minimum error
[err_KNN , k] = min(err); 
cm_KNN = cm{k};           
knnTestRunningTime = toc;  
save knnTestResults
end