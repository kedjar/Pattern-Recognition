%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

function cm = c_matrix(n_classes, predict)
% Computing the confusion matrix

n_elements = numel(predict) / n_classes; % number of elements per class
cm = zeros(n_classes , n_classes);

for ii = 1:n_classes
    index = 1 + (ii-1)*n_elements : ii*n_elements;
    for jj = 1:n_classes
        cm(ii , jj) = sum(predict(index) == jj);
    end    
end