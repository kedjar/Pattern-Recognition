%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

nSamplesPerVal = floor(0.20*nSamples);
learningIndex =  zeros(nSamples - nSamplesPerVal,5);
validationIndex = zeros(nSamplesPerVal,5);

learningIndex(:,1) = [164:815]';        validationIndex(:,1) = [1:163]'; 
learningIndex(:,2) = [1:163 327:815]';  validationIndex(:,2) = [164:326]'; 
learningIndex(:,3) = [1:326 490:815]';  validationIndex(:,3) = [327:489]'; 
learningIndex(:,4) = [1:489 653:815]';  validationIndex(:,4) = [490:652]'; 
learningIndex(:,2) = [1:652]';          validationIndex(:,5) = [653:815]'; 