%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
function [err_SVM, cm_SVM, err] = Classify_SVM(data_l, labels_l, ~, ...
                                             data_v, labels_v, ~, ...
                                             n_classes)             
% Train the model
Vx = data_v;
Vy = labels_v;
Vx_mtx = zeros(numel(Vy) , n_classes);
%predicted = zeros(numel(Vy),1);
g_e = -5:0;
C_e = 0:5;

g = 10.^(g_e); %logspace(-4,0,6);%[10.^((2:-0.1:0.1)) 10.^(-(0:0.1:10))];%[0.1 0.01 0.001 0.0001];%
C = 10.^(C_e); % logspace(-1,5,6);%[10.^(-(10:-0.1:0.1)) 10.^(0:0.1:10)];%[ 1 10 100 1000 10000]; %
error_mtx = zeros(numel(g) , numel(C));
svm_training_running_time = zeros(numel(g) , numel(C),n_classes);
svm_test_running_time =zeros(numel(g) , numel(C),n_classes);
for i = 1:numel(g)  
    gkernel = g(i); 
    for j = 1:numel(C)
           c = C(j);    cj = C(j);
        for class_number = 1:n_classes
            sprintf('**************************************\n g = %05f, C = %05f, class = %d\n **************************************', gkernel , c, class_number)
            ind_minus = labels_l ~= class_number;
            %ind_plus = find(labels_l == class_number);
            Tx = data_l;
            Yx = ones(size(labels_l));    Yx(ind_minus) = -1;
                        
            param = ['-t 2 -g ' num2str(gkernel) ' -c ' num2str(c) ' -j ' num2str(cj)] ;
            tic
            model = mexsvmlearn(Tx, Yx, param); % Tx and Yx are the training data and their labels
            svm_training_running_time(i , j, class_number ) = toc
            tic
            [rate,output] = mexsvmclassify(Vx, Vy,model);  % Vx and Vy are the validation samples and their labels
            svm_test_running_time(i , j, class_number ) = toc
            Vx_mtx(: , class_number) = output;
        end
        [value , index] =  max(Vx_mtx');
        
        predicted = index';
        error = sum(predicted ~= Vy);
        error_mtx(i , j) = error;
        save error_mtx error_mtx i j;
    end
end
err_SVM=0; cm_SVM=0; err =error_mtx;
save svm_new_results_11_20_2016
disp('done!'); 
end