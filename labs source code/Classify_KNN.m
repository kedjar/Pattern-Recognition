%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
function [err_KNN, cm_KNN, err] = Classify_KNN(data_l, labels_l, ind_l, ...
                                             data_v, labels_v, ind_v, ...
                                             n_classes, knn_v)
                                         
                                      
% data_l and labels_l: data for learning
% data_v and labels_v: data for validation

predict_l = zeros(numel(labels_v) ,  numel(knn_v)); % predicted labels
cm = cell(1 , numel(knn_v));
d = zeros(numel(labels_v) , numel(labels_l));

for i = 1 : numel(labels_v)
    xi = repmat(data_v(i , :), numel(labels_l), 1); % the sample i 
    d(i , :) = sum((xi - data_l).^2 , 2);       
end

res_KNN = cell(numel(labels_v) , numel(knn_v));
for i = 1 : numel(labels_v)
 [~ , ind] = sort(d(i , :), 'ascend');
    for j = 1 : numel(knn_v);
        n_neighbors = knn_v(j);
        [index , maxindex] = max_index(labels_l(ind(1 : n_neighbors)));
        predict_l(i , j) = maxindex;
%         opt.k = n_neighbors;
%         opt.sample = ind_v(i);
%         opt.origin_index = ind(1 : n_neighbors);
%         opt.labels = labels_l(ind(1 : n_neighbors));
%         opt.sq_distance = d(i , ind(1 : n_neighbors))';
%         opt.predict = maxindex;
%         opt.per_class = index;
%         res_KNN{i , j} = opt;
    end
end

% confusion matrix
for j = 1 : numel(knn_v)
    cm{j} = c_matrix(n_classes , predict_l(: , j));
end

err = sum(predict_l ~= repmat(labels_v,1,length(knn_v)) , 1) / (length(labels_v));

% compute the minimum error
[err_KNN , k] = min(err); 
cm_KNN = cm{k};



end
