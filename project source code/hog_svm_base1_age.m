%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

clear, clc, close all
path_to_age_adiencefaces_256 = 'data\age\adienfaces_256'; % Base 1 '..\databases\age\adienfaces_256'

%Computing the features
[labels_1, list_images_1] =  get_list_images(path_to_age_adiencefaces_256);

nSamples_1 = numel(labels_1);                
index_ratio_1 = floor(0.7 * nSamples_1);
random_index_1 = randperm(nSamples_1);
                
               
target_CellSize = [10];
target_BlockSize = [3];
target_BlockOverlap = [2 2];
target_NumBins = 15;%[6 9 15 18 24 32];
kk=1;
for cell_size = 1:1
    for block_size = 1:1
        %for block_overlap = 1:4
        for num_bins = 1:1
            % Setting the HOG Parameters
            CellSize = [target_CellSize(cell_size) target_CellSize(cell_size)];
            BlockSize = [target_BlockSize(block_size) target_BlockSize(block_size)];
            BlockOverlap = ceil(BlockSize/(target_BlockOverlap(1)));
            NumBins = target_NumBins(num_bins);
            %fprintf('CellSize: %d, BlockSize: %d, BlockOverlap: %d, NumBins: %d \n',...
            %    CellSize(1),BlockSize(1), BlockOverlap(1),NumBins(1))
            hog_parameters.CellSize = CellSize;
            hog_parameters.BlockSize = BlockSize;
            hog_parameters.BlockOverlap = BlockOverlap;
            hog_parameters.NumBins = NumBins;
            if((BlockSize(1) - BlockOverlap(1))>0)
                [hog_parameters_1, hog_features_1] = get_hog_features_v3(hog_parameters, list_images_1);
               
                
               
                
                train_index_1 = random_index_1(1 : index_ratio_1);
                test_index_1 = random_index_1(index_ratio_1+1 : nSamples_1);
                %Training set
                hog_trainData_1 = hog_features_1(train_index_1,:);
                trainLabels_1 = labels_1(train_index_1);
                %Test set
                hog_testData_1 = hog_features_1(test_index_1,:);
                testLabels_1 = labels_1(test_index_1);
                  libsvm_test_demo
                %HOG SVM                
                hog_svm_model_1 = fitcecoc(hog_trainData_1,trainLabels_1);              
                prediction_1 = zeros(numel(test_index_1), 1);                
                for i = 1:numel(test_index_1)
                    hog_target_1 = hog_testData_1(i,:);                    
                    prediction_1(i,1) = hogsvm_predict(hog_svm_model_1, hog_target_1);                   
                end               
                error_1 = (100/numel(test_index_1))*sum(prediction_1 ~= repmat(testLabels_1' , 1, 1 ) , 1);
                error_mtx_1(kk,:) = error_1;
                prediction_mtx_1{kk} = prediction_1;                               
                
               
                kk=kk+1;   
                fprintf('CellSize: %d, BlockSize: %d, BlockOverlap: %d, NumBins: %d \n',...
                    CellSize(1),BlockSize(1), BlockOverlap(1),NumBins(1))
                fprintf('error1 %05f\n', error_1);
            
            end
        end       
    end
end
disp('done');