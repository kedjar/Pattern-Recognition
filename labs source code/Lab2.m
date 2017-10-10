%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

clear
clc

load zoneProject_60x50x5_learning
data = trans_acp(databaseZoneProject,15);
rate = overlap_v2(data',labels)

index = randperm(6000);
ind1 = index(1:5000);
ind2 = index(5001:6000);

% mais utiliser mes indices (les memes pour tout le monde)
load indexTr
load indxTst
gkernel=0.002
gam = 10;
[rate1 predict] = SVM_1vsAll(data(ind1,:), labels(ind1), data(ind2,:), labels(ind2), gkernel,gam) ;
[rate2 predict]= Classify_KNN(data(ind1,:), labels(ind1), data(ind2,:), labels(ind2), 1);
[rate3 predict]= Classify_QBayes(data(ind1,:), labels(ind1), data(ind2,:), labels(ind2));

rate1
rate2 
rate3

