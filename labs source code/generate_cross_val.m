%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

clear, clc, close all
load train_data
[nSamples , nFeatures] = size(train_features);
nClasses = 10;
nSamplesPerClass = nSamples/nClasses;
x = 2:(nSamplesPerClass);
rateValidationVector = 1./x(~(rem(nSamplesPerClass, x)));
for q = 1:numel(rateValidationVector)
rateValidation = rateValidationVector(q);

rateLearning = 1 - rateValidation;
nCrossVal = int32(1/(1-rateLearning)); % Number of cross validations
 
indexClassValidation = int32((nSamples / nClasses) / nCrossVal);
indexClassLearning = int32((nSamples / nClasses) - indexClassValidation);
IndexAllValidation = cell(1 , nCrossVal);
IndexAllLearning = cell(1 , nCrossVal);
targetClassLabel = ones(1,(nSamples / nClasses));
tempIndex = int32(1:(nSamples / nClasses));

for nn = 1:nCrossVal
    %nCrossVal
    %nn
    IndexAllValidation{nn} = (nn - 1)*indexClassValidation + 1 : nn*indexClassValidation;
    tempLabel = ones(1,(nSamples / nClasses));
    tempLabel(IndexAllValidation{nn}) = -1;
    IndexAllLearning{nn} = tempIndex(tempLabel == targetClassLabel);
end

indexLearning = zeros(int32(rateLearning*numel(train_labels)), nCrossVal);
indexValidation = zeros(int32((1-rateLearning)*numel(train_labels)), nCrossVal);

for n =  1:nClasses
    tempIndex = find(train_labels == n);
    randomIndex = tempIndex(randperm(numel(tempIndex)));  
    startIndexI1 = int32((n - 1) * (nSamples / nClasses) * rateLearning + 1) ;
    endIndexI1   = int32(n * (nSamples / nClasses) * rateLearning);
    I1 = startIndexI1:endIndexI1 ;
    startIndexI2 = int32((n - 1) * (nSamples / nClasses) * (1 - rateLearning) + 1);
    endIndexI2   = int32(n * (nSamples / nClasses) * (1 - rateLearning));
    I2 = startIndexI2 : endIndexI2 ;
    for m = 1:nCrossVal
        indexLearning  (I1 , m ) = randomIndex(IndexAllLearning{m});
        indexValidation(I2 , m ) = randomIndex(IndexAllValidation{m});
    end
end
fileToSave = strcat('IndexCrossValidation_k_', num2str(nCrossVal), '.mat');
save(fileToSave , 'indexLearning', 'indexValidation');
skip = false;
if(~skip)
    % Check the results are consistent
    indexAll = 1:numel(train_labels);
    
    for n = 1 : size(indexLearning , 2)
        iL = indexLearning  (: , n);
        iV = indexValidation(: , n);
%         subplot(2,1,1), plot(iL, 'r.');grid
%         title(sprintf('n= %d, r_v = %02f', n, rateValidation))
%         subplot(2,1,2), plot(iV, 'b.');grid
         indexAllAfterCV = sort([ iL ; iV ]);
        test(n) = sum(indexAll' - indexAllAfterCV);
    end
end

sum(test)
end
disp('done!' )
    
    
    
    
    