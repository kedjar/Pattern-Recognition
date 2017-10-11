%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

function [err_SVM, cm_SVM, optim_params, svmValRunningTime] = Classify_SVM_Val(data, ...
                                 labels, ...
                                 indexLearning,...
                                 indexValidation,...
                                 n_classes)
tic 
doCrossValidation = true;
if doCrossValidation
    nCrossValidation = size(indexValidation , 2);
else
    nCrossValidation = 1;
end
g_e = -3;%-4:-1;
C_e = 2;%0:4;
g = 10.^(g_e);
C = 10.^(C_e);
error_mtx = zeros(numel(g) , numel(C), nCrossValidation);

for ncv = 1:nCrossValidation
    Tx = data(indexLearning(: , ncv), :);  % Learning data set
    labels_l = labels(indexLearning(: , ncv));
    Yx = ones(size(labels_l)); % TO contains the labels in the 1 against all strategy
    Vx = data(indexValidation(: , ncv), :);% Validation data set
    Vy = labels(indexValidation(: , ncv));  % Validation labels    
    Vx_mtx = zeros(numel(Vy) , n_classes);   
    for i = 1:numel(g)        
        for j = 1:numel(C)            
            for classNumber = 1:n_classes
                disp(strcat('g = ', num2str(g(i)), ' C = ', num2str(C(j)), ' Class =' , num2str(classNumber)))
                indexMinus = labels_l ~= classNumber;  
                indexPlus = labels_l == classNumber;                    
                Yx(indexMinus) = -1;    
                Yx(indexPlus)  =  1;  
                param = ['-t 2 -g ' num2str(g(i)) ' -c ' num2str(C(j)) ' -j ' num2str(C(j))] ;
                model = mexsvmlearn(Tx, Yx, param); % Tx and Yx are the training data and their labels                
                [~,output] = mexsvmclassify(Vx, Vy,model);  % Vx and Vy are the validation samples and their labels
                Vx_mtx(: , classNumber) = output;
            end
            [~ , predicted] =  max(Vx_mtx,[],2);            
            error_mtx(i , j, ncv) = sum(predicted ~= Vy);            
        end
    end   
end
cm_SVM=0;
err_SVM = error_mtx;
optim_params = [0.001, 100];
svmValRunningTime = toc;
end