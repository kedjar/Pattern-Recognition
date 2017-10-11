%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

face_db_main_path = 'datasets\gender';
face_db_new_path_l = 'datasets\gender_l';
face_db_new_path_c = 'datasets\gender_c';
classes = {'m', 'w'};
params = [200, 10, 2.6];
disp('Processing step 1...') 
for classNumber = 1:2
    correct_luminance(face_db_main_path, face_db_new_path_l,  classes, classNumber, params)
    crop_database(face_db_main_path, face_db_new_path_c,  classes, classNumber)
end


face_db_main_path = 'datasets\gender_l';
face_db_new_path = 'datasets\gender_l_c';
classes = {'m', 'w'};
disp('Processing step 2...') 
for classNumber = 1:2
    crop_database(face_db_main_path, face_db_new_path,  classes, classNumber)
end

faceDetector = vision.CascadeObjectDetector();
face_db_main_path = 'datasets\gender_l';
face_db_new_path = 'datasets\gender_l_c_matlab';
classes = {'m', 'w'};
disp('Processing step 2...') 
for classNumber = 1:2
    crop_database_matlab(face_db_main_path, face_db_new_path,  classes, classNumber, faceDetector)
end


face_db_main_path = 'datasets\gender_l_c_matlab';
classes = {'m', 'w'};
classNumber = 2
img_size = mean_size(face_db_main_path,  classes, classNumber)
mean(img_size,1)


newSize =[300 300; 200 200; 150 150; 100 100; 50 50; 500 500]
face_db_main_path = 'datasets\gender_l_c_matlab';
classes = {'m', 'w'};

face_db_new_path = 'datasets\gender_l_c_matlab_r500';
for classNumber = 1:2
    resize_database(face_db_main_path, face_db_new_path,  classes, newSize(6,:), classNumber)
end