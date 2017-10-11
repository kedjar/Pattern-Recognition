%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

% newSize =[800 800; 500 500; 300 300; 200 200; 100 100; 50 50]
% face_db_main_path = 'datasets\project\gender_c';
% classes = {'1', '2'};
% 
% face_db_new_path = 'datasets\project\gender_c_r50';
% for classNumber = 1:2
%     resize_database(face_db_main_path, face_db_new_path,  classes, newSize(6,:), classNumber)
% end

newSize =[800 800; 500 500; 300 300; 200 200; 100 100; 50 50]
face_db_main_path = 'datasets\project\age_c';
classes = {'1', '2','3', '4','5', '6','7', '8'};

face_db_new_path = 'datasets\project\age_c_r50';
for classNumber = 1:8
    resize_database(face_db_main_path, face_db_new_path,  classes, newSize(6,:), classNumber)
end