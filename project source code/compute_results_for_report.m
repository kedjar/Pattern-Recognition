%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

mk_colors
number_of_trials = 20;
test_vector_length =[396 374 352 330 308 286 264 242 220 199 177 155 132 110 89 66 45 22];
vect_test = repmat(test_vector_length, number_of_trials,1);
%results_per_trial{trial,2} = error_mtx;
%results_per_trial{trial,3} = time_mtx;
% Load the results
fisher_results = zeros( numel(ratio), number_of_trials);
pca_results = zeros( numel(ratio), number_of_trials);
hog_svm_results = zeros( numel(ratio), number_of_trials);
hog_lda_results = zeros( numel(ratio), number_of_trials);
for tt = 1:number_of_trials
    temp = results_per_trial{tt,2};
    fisher_results(:,tt) = temp(:,1);
    pca_results(:,tt) = temp(:,2);
    hog_svm_results(:,tt) = temp(:,3);
    hog_lda_results(:,tt) = temp(:,4);
end

%mean and variance
M = [mean(fisher_results')'  mean(pca_results')'  mean(hog_svm_results')' mean(hog_lda_results')'];
M = 100-M;
V=[ var(fisher_results')'  var(pca_results')'  var(hog_svm_results')'  var(hog_lda_results')'];
[ratio' M V]

close all
figure, hold on, grid on

boxplot(100-fisher_results(1:1:end,:)', 'Colors', crimson, 'PlotStyle','traditional', 'Symbol', 'r+')
boxplot(100-pca_results(1:1:end,:)', 'Colors', mountainmeadow, 'PlotStyle','traditional', 'Symbol', 'g*')
plot(100-mean(fisher_results',1),  'Color', crimson, 'LineStyle','-.','Marker', '+', 'LineWidth', 1.5 )
plot(100-mean(pca_results', 1), 'Color', mountainmeadow, 'LineStyle','-.','Marker', '*', 'LineWidth', 1.5)
legend('LDA-KNN' , 'PCA-KNN')
axis([0 19 73 101])
set(gca,'XTickLabel',{' '})
set(gca, 'Xtick',1:2:18,'XTickLabel',mat2cell(ratio(1:2:18), 1,numel(ratio(1:2:18))))

%set(gca, 'Xtick',1:2:18,'XTickLabel',mat2cell(ratio(1:2:18), 1,numel(ratio(1:2:18))))
ylabel('precision (%)')
xlabel('Proportion de l'' ensemble d''apprentissage');
title('Résultats pour la base de données Caltech')

figure, hold on, grid on
boxplot(100-hog_svm_results(1:1:end,:)', 'Colors', crimson, 'PlotStyle','traditional', 'Symbol', 'rs')
plot(100-mean(hog_svm_results', 1), 'Color', crimson, 'LineStyle','-.','Marker', 's', 'LineWidth', 1.5)
legend('HOG-SVM')
axis([0 19 95 101])
set(gca,'XTickLabel',{' '})
set(gca, 'Xtick',1:2:18,'XTickLabel',mat2cell(ratio(1:2:18), 1,numel(ratio(1:2:18))))
ylabel('precision (%)')
xlabel('Proportion de l'' ensemble d''apprentissage');
title('Résultats pour la base de données Adience')

figure, hold on, grid on
boxplot(100-hog_lda_results(1:1:end,:)', 'Colors', mountainmeadow, 'PlotStyle','traditional', 'Symbol', 'go')
plot(100-mean(hog_lda_results', 1), 'Color', mountainmeadow, 'LineStyle','-.','Marker', 'o', 'LineWidth', 1.5)
legend('HOG-LDA-KNN')
axis([0 19 95 101])
set(gca,'XTickLabel',{' '})
set(gca, 'Xtick',1:2:18,'XTickLabel',mat2cell(ratio(1:2:18), 1,numel(ratio(1:2:18))))
ylabel('precision (%)')
xlabel('Proportion de l'' ensemble d''apprentissage');
title('Résultats pour la base de données Adience')

%figure, hold on, grid on

% plot(100-mean(fisher_results',1),  'Color', crimson, 'LineStyle','-.','Marker', '+', 'LineWidth', 1.5 )
% plot(100-mean(pca_results', 1), 'Color', mountainmeadow, 'LineStyle','-.','Marker', '*', 'LineWidth', 1.5)
% 
% plot(100-mean(hog_svm_results', 1), 'Color', majorelleblue, 'LineStyle','-.','Marker', 's', 'LineWidth', 1.5)
% plot(100-mean(hog_lda_results', 1), 'Color', chartreuse_web, 'LineStyle','-.','Marker', 'o', 'LineWidth', 1.5)

set(gca,'XTickLabel',{' '})
set(gca, 'Xtick',1:1:18,'XTickLabel',mat2cell(ratio(1:1:18), 1,numel(ratio(1:1:18))))
ylabel('precision (%)')
xlabel('Proportion de l'' ensemble d''apprentissage');
title('Résultats pour la base de données Caltech')
%title('Résultats pour la base de données AdienceFaces (3 groupes d''age)')
legend('LDA-KNN' , 'PCA-KNN', 'HOG-SVM', 'HOG-LDA-KNN')
%legend('PCA', 'HOG-SVM')

% figure, hold on, grid on
% plot(100-100*mean(fisher_final_error,1), 'Color', crimson)
% plot(100-100*mean(pca_final_error), 'Color', outerspace)
% plot(100-100*mean(hog_final_error), 'Color', iris)
% set(gca, 'Xtick',1:2:18,'XTickLabel',mat2cell(train_ratio(1:2:18), 1,numel(train_ratio(1:2:18))))
% ylabel('precision')
% xlabel('Proportion de l'' ensemble d''apprentissage');
% title('Résultats pour la base de données Caltech')
% legend('LDA', 'PCA', 'HOG-SVM')
% clc

% Temps de calcul

for tt = 1:number_of_trials
    temp = results_per_trial{tt,3};
    fisher_time_train(:,tt) = temp(:,1);
    pca_time_train(:,tt) = temp(:,2);
    hog_svm_time_train(:,tt) = temp(:,3);
    hog_lda_time_train(:,tt) = temp(:,4);
    fisher_time_test(:,tt) = temp(:,5);
    pca_time_test(:,tt) = temp(:,6);
    hog_svm_time_test(:,tt) = temp(:,7);
    hog_lda_time_test(:,tt) = temp(:,8);
end
t1 = mean(fisher_time_train,2);
t2 = mean(pca_time_train, 2);
t3 = mean(hog_svm_time_train,2);
t4 = mean(hog_lda_time_train,2);
t5 = mean(fisher_time_test,2);
t6 = mean(pca_time_test,2);
t7 = mean(hog_svm_time_test,2);
t8 = mean(hog_lda_time_test,2); 






fisher_train_runtime = zeros(1 , numel(train_ratio));
for tt=1:number_of_trials
    fisher_train_runtime = fisher_train_runtime + cell_run_time_per_trial{tt,1};
end

fisher_train_runtime = fisher_train_runtime/number_of_trials;

pca_train_runtime = zeros(1 , numel(train_ratio));
for tt=1:number_of_trials
    pca_train_runtime = pca_train_runtime + cell_run_time_per_trial{tt,2};
end

pca_train_runtime = pca_train_runtime/number_of_trials;

hog_train_runtime = zeros(1 , numel(train_ratio));
for tt=1:number_of_trials
    hog_train_runtime = hog_train_runtime + cell_run_time_per_trial{tt,3};
end

hog_train_runtime = hog_train_runtime/number_of_trials;




fisher_test_runtime = zeros(1 , numel(train_ratio));
for tt=1:number_of_trials
    fisher_test_runtime = fisher_test_runtime + mean(cell_run_time_per_trial{tt,4},1);
end

fisher_test_runtime = fisher_test_runtime/number_of_trials;

pca_test_runtime = zeros(1 , numel(train_ratio));
for tt=1:number_of_trials
    pca_test_runtime = pca_test_runtime + mean(cell_run_time_per_trial{tt,5},1);
end

pca_test_runtime = pca_test_runtime/number_of_trials;

hog_test_runtime = zeros(1 , numel(train_ratio));
for tt=1:number_of_trials
    hog_test_runtime = hog_test_runtime + cell_run_time_per_trial{tt,6};
end

hog_test_runtime = hog_test_runtime/number_of_trials;

figure, 
semilogy(t1, 'Color', crimson,'Marker', '+', 'LineWidth', 1.5),hold on, 
semilogy(t2, 'Color', mountainmeadow,'Marker', '*', 'LineWidth', 1.5),hold on, 
semilogy(t3, 'Color', majorelleblue,'Marker', 's', 'LineWidth', 1.5),hold on, 
semilogy(t4, 'Color', chartreuse_web,'Marker', 'o', 'LineWidth', 1.5),hold on, 
% set(gca, 'Xtick',1:2:18,'XTickLabel',mat2cell(train_ratio(1:2:18), 1,numel(train_ratio(1:2:18))))
% ylabel('temps de calcul pour la phase d''apprentissage (s)')
% xlabel('Proportion de l'' ensemble d''apprentissage');
% title('Résultats pour la base de données Caltech')
 legend('LDA-KNN', 'PCA-KNN', 'HOG-SVM', 'HOG-LDA-KNN')
% grid on
% clc

% figure,grid on
semilogy(t5, 'Color', crimson,'Marker', '+', 'LineStyle','-.', 'LineWidth', 1.5), hold on, 
semilogy(t6, 'Color', mountainmeadow,'Marker', '*', 'LineStyle','-.', 'LineWidth', 1.5), hold on, 
semilogy(t7, 'Color', majorelleblue,'Marker', 's', 'LineStyle','-.', 'LineWidth', 1.5), hold on, 
semilogy(t8, 'Color', chartreuse_web,'Marker', 'o', 'LineStyle','-.', 'LineWidth', 1.5), hold on, 
set(gca, 'Xtick',1:2:18,'XTickLabel',mat2cell(ratio(1:2:18), 1,numel(ratio(1:2:18))))
ylabel('temps de calcul(s)')
xlabel('Proportion de l''ensemble d''apprentissage');
title('Résultats pour la base de données AdienceFaces (3 groupes d''age)')
% legend('LDA', 'PCA', 'HOG-SVM')
grid on
clc

% vect_test = repmat(test_vector_length, numel(knn_vector),1)
% e = zeros(numel(knn_vector) , numel(train_ratio));
% for tt = 1:number_of_trials
%     e = e + cell_error_rate_per_trial{tt,3};
%     
% end
% e = e/(number_of_trials)
% e./test_vector_length
% 
% 
% 
% 
% vect_test = repmat(test_vector_length, numel(knn_vector),1)
% e = zeros(1 , numel(train_ratio));
% for tt = 1:number_of_trials
%     e = e + cell_error_rate_per_trial{tt,3};
%     
% end
% e = e/(number_of_trials)
% e./test_vector_length