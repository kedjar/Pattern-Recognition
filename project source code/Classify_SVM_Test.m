%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

function predicted = Classify_SVM_Test(trainData, ...
                                 trainLabels, ...
                                 testData, ...
                                 testLabels, ...
                                 nClasses)

g = 0.001;%[0.1 0.05 0.01 0.0075 0.005 0.003 0.001 0.00075 0.0005  0.00035  0.0002 0.0001];
C = 100;%[1   5    10   30     70    100   200     500    1000    3000     6000   10000];
optim_params{1} = g;  optim_params{2} = C;
Yx = ones(size(trainLabels));
Vx_mtx = zeros(numel(testLabels) , nClasses);
g = optim_params{1};
C = optim_params{2};
error_mtx = zeros(numel(g) , numel(C));
time_mtx_train = zeros(numel(g) , numel(C), nClasses);
time_mtx_test = zeros(numel(g) , numel(C), nClasses);
for i = 1:numel(g)       
    for j = 1:numel(C)       
        for classNumer = 1:nClasses
            tic
            indexMinus = trainLabels ~= classNumer;
            indexPlus  = trainLabels == classNumer;           
            Yx(indexMinus) = -1;
            Yx(indexPlus)  =  1;                        
            param = ['-t 2 -g ' num2str(g(i)) ' -c ' num2str(C(j)) ' -j ' num2str(C(j))] ;
            % Train the model
            model = mexsvmlearn(trainData, Yx, param); % Tx and Yx are the training data and their labels             
            time_mtx_train(i , j, classNumer) = toc;
            tic
            % Test the model
            [~,output] = mexsvmclassify(testData, testLabels,model);  % Vx and Vy are the validation samples and their labels
            Vx_mtx(: , classNumer) = output;
            time_mtx_test(i , j, classNumer) = toc;
        end
        [~ , predicted] =  max(Vx_mtx, [], 2);       
        error_mtx(i , j) = sum(predicted ~= testLabels);         
    end
end
end                            
