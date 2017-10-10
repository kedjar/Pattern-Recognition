%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
function [err_KNN , cm_KNN, k_optimal, knnValRunningTime, prediction_KNN_Val] = Classify_KNN_Val(trainData, ...
                                  trainLabels, ...
                                  learningIndex,...
                                  validationIndex,...
                                  nClasses)
tic
doCrossValidation = false;
if doCrossValidation
    nCrossValidation = size(validationIndex , 2);
else
    nCrossValidation = 1;
end
knnVector = 1:2:11;

prediction_KNN_Val = zeros(size(validationIndex, 1),  numel(knnVector)); % predicted labels
predictedLabelsCell = cell(1 , nCrossValidation);
cm = cell(nCrossValidation , numel(knnVector));
err = zeros(nCrossValidation , numel(knnVector));
knn_val_time = zeros(nCrossValidation , 1);
knn_learn_time = zeros(nCrossValidation , 1);
knn_time_prep = toc;
for ncv = 1:nCrossValidation
    tic
    learningData = trainData(learningIndex(: , ncv), :);
    learningLabels = trainLabels(learningIndex(: , ncv));   
    validationData = trainData(validationIndex(: , ncv), :);
    validationLabels = trainLabels(validationIndex(: , ncv));    
    %Learning
    d = zeros(numel(validationLabels) , numel(learningLabels));    
    for i = 1 : numel(validationLabels)
        xi = repmat(validationData(i , :), numel(learningLabels), 1); % the sample i
        d(i , :) = sum((xi - learningData).^2 , 2);
    end
    knn_learn_time(ncv , 1) = toc;
    
    %Validation
    tic
    for i = 1 : numel(validationLabels)
        [~ , ind] = sort(d(i , :), 'ascend');
        for j = 1 : numel(knnVector);
            n_neighbors = knnVector(j);
            [~ , maxindex] = max_index(learningLabels(ind(1 : n_neighbors)));
            prediction_KNN_Val(i , j) = maxindex;
        end
    end
    predictedLabelsCell{ncv} = prediction_KNN_Val;
    err(ncv, :) = sum(prediction_KNN_Val ~= ...
        repmat(validationLabels,1,numel(knnVector)) , 1) / (numel(validationLabels));
    knn_val_time(ncv , 1) = toc;
end
tic
% Compute the minimum error
mean_err = mean(err , 1);
[err_KNN , err_ind] = min(mean_err); 
k_optimal = knnVector(err_ind);
% Compute the confusion matrix
for i = 1 : ncv
    prediction_KNN_Val = predictedLabelsCell{i};
    for j = 1 : numel(knnVector)
        cm{i , j} = confusionmat(validationLabels, prediction_KNN_Val(: , j));
    end
end
cm_KNN = cm; %cm{: , k_optimal};
knn_save_prep = toc;
knnValRunningTime.t1 = knn_time_prep;
knnValRunningTime.t2 = knn_learn_time;
knnValRunningTime.t3 = knn_val_time;
knnValRunningTime.t4 = knn_save_prep;
%save knnValResults
end