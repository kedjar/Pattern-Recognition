%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

% face_db_main_path = 'datasets\project\gender_c';
% classes = {'1', '2'};
% classNumber = 2
% img_size = mean_size(face_db_main_path,  classes, classNumber)
% mean(img_size,1)





face_db_main_path = 'datasets\project\age_c';
classes = {'1', '2','3', '4','5', '6','7', '8'};
classNumber = 8
img_size = mean_size(face_db_main_path,  classes, classNumber)
mean(img_size,1)
