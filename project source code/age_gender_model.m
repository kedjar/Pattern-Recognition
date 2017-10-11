%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

clc, clear, close all
% path_to_age_adiencefaces_256 = '..\..\databases\age\adienfaces_256'; % Base 1 '..\databases\age\adienfaces_256'
% path_to_gender_adiencefaces_256 = '..\..\databases\gender\adienfaces_256\'; %Base 2
% path_to_gender_caltech_300 = '..\..\databases\gender\caltech_300'; % Base 3
% 
% % Computing the features
% [lda_pca_features_b1, labels_b1, width_b1, height_b1, names_b1, list_images_b1] =  read_images(path_to_age_adiencefaces_256);
% [lda_pca_features_b2, labels_b2, width_b2, height_b2, names_b2, list_images_b2] =  read_images(path_to_gender_adiencefaces_256);
% [lda_pca_features_b3, labels_b3, width_b3, height_b3, names_b3, list_images_b3] =  read_images(path_to_gender_caltech_300);
% [hog_parameters_b1, hog_features_b1] = get_hog_features(list_images_b1);
% [hog_parameters_b2, hog_features_b2] = get_hog_features(list_images_b2);
% [hog_parameters_b3, hog_features_b3] = get_hog_features(list_images_b2);
% 
% save computed_features_and_data
load computed_features_and_data
lda_pca_target_features = lda_pca_features_b1;
hog_target_features = hog_features_b1;
lda_pca_hog_target_labels = labels_b1; 
lda_pca_hog_target_names = names_b1;


% Determine the number of classes
nClasses = numel(lda_pca_hog_target_names);
% Split Data to training and test set
nSamples = size(lda_pca_target_features,2);

for ratio = 0.1:0.05:0.95
    index_ratio = floor(ratio * nSamples);
    random_index = randperm(nSamples);
    train_index = random_index(1 : index_ratio);
    test_index = random_index(index_ratio+1 : nSamples);
    %Training set
    lda_pca_trainData = lda_pca_target_features(:, train_index);
    hog_trainData = hog_target_features(train_index, :);
    trainLabels = lda_pca_hog_target_labels(train_index);
    %Test set
    lda_pca_testData = lda_pca_target_features(:,test_index);
    hog_testData = hog_target_features(test_index, :);
    testLabels = lda_pca_hog_target_labels(test_index);
    
    %compute a model
    %PCA
    pca_components = 100*((index_ratio)>=100) + index_ratio*((index_ratio)<100);
    pca_model = eigenfaces(lda_pca_trainData, trainLabels, pca_components);
    %LDA
    lda_model = fisherfaces(lda_pca_trainData,trainLabels);
    %HOG SVM
    hog_svm_model = fitcecoc(hog_trainData,trainLabels);
    %HOG LDA
    hog_lda_model = fisherfaces(hog_trainData',trainLabels);
    prediction_mtx = zeros(numel(test_index), 5);
    %get a prediction from the model
    for i = 1:numel(test_index)
        lda_pca_target = lda_pca_testData(: , i);
        hog_target = hog_testData(i,:);
        
        prediction_mtx(i,1) = fisherfaces_predict(lda_model, lda_pca_target, 1);
        prediction_mtx(i,2) = eigenfaces_predict(pca_model, lda_pca_target, 1);
        prediction_mtx(i,3) = hogsvm_predict(hog_svm_model, hog_target);
        prediction_mtx(i,4) = fisherfaces_predict(hog_lda_model, hog_target', 1);
    end
    prediction_mtx(:,5) = Classify_SVM_Test(hog_trainData, trainLabels', hog_testData, testLabels', nClasses);
    
    %compute the error rate
    error_mtx = (100/numel(test_index))*sum(prediction_mtx ~= repmat(testLabels' , 1, 5 ) , 1);
end