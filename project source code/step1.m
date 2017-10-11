%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

% faceDetector = vision.CascadeObjectDetector();
% face_db_main_path = 'datasets\project\gender';
% face_db_new_path = 'datasets\project\gender_c';
% classes = {'1', '2'};
% disp('Processing step 2...') 
% for classNumber = 1:2
%     crop_database_matlab(face_db_main_path, face_db_new_path,  classes, classNumber, faceDetector)
% end


faceDetector = vision.CascadeObjectDetector();
face_db_main_path = 'datasets\project\age';
face_db_new_path = 'datasets\project\age_c';
classes = {'1', '2','3', '4','5', '6','7', '8'};
disp('Processing step 2...') 
for classNumber = 1:8
    crop_database_matlab(face_db_main_path, face_db_new_path,  classes, classNumber, faceDetector)
end


'datasets\age_and_gender\age_and_gender_all\gender'