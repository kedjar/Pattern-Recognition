%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

clear,clc,close all
tic
a_folder = 'datasets/age_and_gender/age/';
g_folder = 'datasets/age_and_gender/gender/';
%a_folder = 'datasets/projetv2/Test/age/'; 
%g_folder = 'datasets/projetv2/Test/gender/'; 

load('datasets/sys800/foldfrontaldata.mat')
for k = 5:5
    if(k ==1)
        temp_fold = foldfrontal0data;
    end
    if(k ==2)
        temp_fold = foldfrontal1data;
    end
    if(k ==3)
        temp_fold = foldfrontal2data;
    end
    if(k ==4)
        temp_fold = foldfrontal3data;
    end
    if(k ==5)
        temp_fold = foldfrontal4data;
    end
    f_size = size(temp_fold , 1);
    
    rand_ind = randperm(f_size);
    number_of_pix = f_size;
    target_ind = rand_ind(1:number_of_pix);
    
    for ii1 = 1:number_of_pix
        i = target_ind(ii1);
        file_name = strcat('landmark_aligned_face',...
            '.',num2str(temp_fold{i,3}),...
            '.',temp_fold{i,2});
        image_path = strcat('datasets/sys800/aligned/', temp_fold{i,1}, '/', file_name);
        img_name = temp_fold{i,2};
        age = temp_fold{i,4};
        gender = temp_fold{i,5};
        
        img_c = imread(image_path);
        [img_c_path_age , img_c_path_gender ] = get_img_path2(age , gender, a_folder, g_folder, img_name);
        
        
        imwrite(img_c,img_c_path_age);
        imwrite(img_c,img_c_path_gender);
    end
end
disp('done!')

% Cropping
faceDetector = vision.CascadeObjectDetector();
face_db_main_path = 'datasets\Learning\gender';
face_db_new_path = 'datasets\Learning\gender_c';
classes = {'1', '2'};
disp('Processing step 2...') 
for classNumber = 1:2
    crop_database_matlab(face_db_main_path, face_db_new_path,  classes, classNumber, faceDetector)
end

faceDetector = vision.CascadeObjectDetector();
face_db_main_path = 'datasets\Learning\age';
face_db_new_path = 'datasets\Learning\age_c';
classes = {'1', '2','3', '4','5', '6','7', '8'};
disp('Processing step 2...') 
for classNumber = 1:8
    crop_database_matlab(face_db_main_path, face_db_new_path,  classes, classNumber, faceDetector)
end

% Resizing
%newSize =[800 800; 500 500; 300 300; 200 200; 100 100; 50 50];
newSize =[64 64];
face_db_main_path = 'datasets\Learning\gender_c';
classes = {'1', '2'};
for i = 1:size(newSize,1)
    face_db_new_path = strcat('datasets\Learning\gender_c_r', num2str(newSize(i,1)));
    for classNumber = 1:2
        resize_database(face_db_main_path, face_db_new_path,  classes, newSize(i,:), classNumber)
    end
end

face_db_main_path = 'datasets\Test\gender_c';
classes = {'1', '2'};
for i = 1:size(newSize,1)
    face_db_new_path = strcat('datasets\Test\gender_c_r', num2str(newSize(i,1)));
    for classNumber = 1:2
        resize_database(face_db_main_path, face_db_new_path,  classes, newSize(i,:), classNumber)
    end
end

face_db_main_path = 'datasets\Learning\age_c';
classes = {'1', '2','3', '4','5', '6','7', '8'};
for i = 1:size(newSize,1)
    face_db_new_path = strcat('datasets\Learning\age_c_r', num2str(newSize(i,1)));
    for classNumber = 1:8
        resize_database(face_db_main_path, face_db_new_path,  classes, newSize(i,:), classNumber)
    end
end

face_db_main_path = 'datasets\Test\age_c';
classes = {'1', '2','3', '4','5', '6','7', '8'};
for i = 1:size(newSize,1)
    face_db_new_path = strcat('datasets\Test\age_c_r', num2str(newSize(i,1)));
    for classNumber = 1:8
        resize_database(face_db_main_path, face_db_new_path,  classes, newSize(i,:), classNumber)
    end
end

toc

