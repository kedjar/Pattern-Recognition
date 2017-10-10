%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
 function [err_QBayes , cm_QBayes, runtimeQBayes, prediction_QBayes] = Classify_QBayes(trainData, ...
                                                     testData, ...
                                                     testLabels)
% Implementing the Quadratic Bayes
% Parameters estimation
tic
nClasses = 10;
[nTrainSamples , nFeatures] = size(trainData);
[nTestSamples , ~] = size(testData);
nSamplesPerClass = nTrainSamples / nClasses;
mu = zeros(nClasses , nFeatures);             % Mean features vectors
S    = cell(nClasses , 1);                    % Covariance matrices
invS = cell(nClasses , 1);                    % Inverse Covariance matrices
detS = cell(nClasses , 1);                    % Determinant Covariance matrices

for ii = 1:nClasses
    index = 1 + (ii-1)*nSamplesPerClass : ii*nSamplesPerClass;
    mu(ii , :) = mean(trainData(index , :));
    S{ii} = cov(trainData(index , :));
    invS{ii} = inv(S{ii});
    detS{ii} = det(S{ii});
end
QBayesTrainingTime = toc;

tic
% Making predictions
prediction_QBayes = zeros(nTestSamples,1);
for ii = 1:nTestSamples;
    d = zeros(nClasses,1);
    for jj = 1:nClasses
        d(jj) = - (1/2)*log(detS{jj}) ...
            - (1/2)*(testData(ii , :) - mu(jj , :))...
            *invS{jj}*((testData(ii , :) - mu(jj , :)))';
    end
    [~,index] = sort(d, 'descend'); % sorting the result from the bigger to the smaller
    prediction_QBayes(ii) = index(1);
end

% Computing the confusion matrix
cm_QBayes = confusionmat(testLabels, prediction_QBayes);
% Calcul the error rate
err_QBayes = sum(prediction_QBayes ~= testLabels) / nTestSamples;

QBayesTestingTime = toc;
runtimeQBayes = [ QBayesTrainingTime ; QBayesTestingTime];
save QBayesResults
end 
