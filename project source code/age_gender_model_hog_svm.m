%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

clear, clc, close all
path_to_age_adiencefaces_256 = 'data\age\adienfaces_256'; % Base 1 '..\databases\age\adienfaces_256'
path_to_gender_adiencefaces_256 = 'data\gender\adienfaces_256\'; %Base 2
%path_to_gender_caltech_300 = '..\data\gender\caltech_300'; % Base 3

%Computing the features
[labels_1, list_images_1] =  get_list_images(path_to_age_adiencefaces_256);
[labels_2, list_images_2] =  get_list_images(path_to_gender_adiencefaces_256);
%[labels_b3, list_images_b3] =  get_list_images(path_to_gender_caltech_300);

nSamples_1 = numel(labels_1);                
index_ratio_1 = floor(0.7 * nSamples_1);
random_index_1 = randperm(nSamples_1);
                
nSamples_2 = numel(labels_2);                
index_ratio_2 = floor(0.7 * nSamples_2);
random_index_2 = randperm(nSamples_2);
                
target_CellSize = [12 10 8 4];
target_BlockSize = [4 3 2 1];
target_BlockOverlap = [2 2];
target_NumBins = 9;%[6 9 15 18 24 32];
kk=1;
for cell_size = 1:4
    for block_size = 1:4
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
                [hog_parameters_2, hog_features_2] = get_hog_features_v3(hog_parameters, list_images_2);
                %hog_overlap_b1 = overlap_v3(hog_features_b1,labels_b1);
                %hog_overlap_b2 = overlap_v3(hog_features_b2,labels_b2);
                %fprintf('Overlap base 1: %05f, Overlap base 2: %05f \n', hog_overlap_b1, hog_overlap_b2)
                %hog_features_2 = hog_features_b2;
                %labels_2 = labels_b2;
                % Determine the number of classes
                %nClasses = numel(lda_pca_hog_target_names);
                % Split Data to training and test set
                %1st base
                
               
                
                train_index_1 = random_index_1(1 : index_ratio_1);
                test_index_1 = random_index_1(index_ratio_1+1 : nSamples_1);
                %Training set
                hog_trainData_1 = hog_features_1(train_index_1,:);
                trainLabels_1 = labels_1(train_index_1);
                %Test set
                hog_testData_1 = hog_features_1(test_index_1,:);
                testLabels_1 = labels_1(test_index_1);
                
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
                
                % 2nd base
             
                
                train_index_2 = random_index_2(1 : index_ratio_2);
                test_index_2 = random_index_2(index_ratio_2+1 : nSamples_2);
                %Training set
                hog_trainData_2 = hog_features_2(train_index_2,:);
                trainLabels_2 = labels_2(train_index_2);
                %Test set
                hog_testData_2 = hog_features_2(test_index_2,:);
                testLabels_2 = labels_2(test_index_2);
                
                %HOG SVM               
                hog_svm_model_2 = fitcecoc(hog_trainData_2,trainLabels_2);              
                prediction_2 = zeros(numel(test_index_2), 1);               
                for i = 1:numel(test_index_2)
                    hog_target_2 = hog_testData_2(i,:);                  
                    prediction_2(i,1) = hogsvm_predict(hog_svm_model_2, hog_target_2);                  
                end               
                error_2 = (100/numel(test_index_2))*sum(prediction_2 ~= repmat(testLabels_2' , 1, 1 ) , 1);
                error_mtx_2(kk,:) = error_2;
                prediction_mtx_2{kk} = prediction_2;
                kk=kk+1;   
                fprintf('CellSize: %d, BlockSize: %d, BlockOverlap: %d, NumBins: %d \n',...
                    CellSize(1),BlockSize(1), BlockOverlap(1),NumBins(1))
                fprintf('error1 %05f, error2 %05f \n', error_1, error_2);
            
            end
        end       
    end
end
disp('done');