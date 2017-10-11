%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

% each file foldfrontalXdata, X = 0, 1, 2, 3, 4 contains the following data
% user_id, original_image, face_id, age, gender, x,	y, dx, dy, tilt_ang, fiducial_yaw_angle, fiducial_score
path_to_images = 'datasets/sys800/aligned';
list_of_folders = dir(path_to_images);
list_of_images = cell(19370,2);
k=1;
for folderNumber = 1:numel(list_of_folders)
    folder_name = list_of_folders(folderNumber).name;
    if(strcmp(folder_name, '.') == 0 && strcmp(folder_name, '..') ==0)
        temp_folder = folder_name;%(strcat('datasets/sys800/aligned/',folder_name,'/', file_name));
        list_of_files = dir(strcat('datasets/sys800/aligned/',folder_name));
        for fildeNumber = 1:numel(list_of_files)
            file_name = list_of_files(fildeNumber).name;
            if(strcmp(file_name, '.') == 0 && strcmp(file_name, '..') ==0)
                temp_file = file_name;
                list_of_images{k,1} = folder_name;
                list_of_images{k,2} = file_name; %(strcat('datasets/sys800/aligned/',folder_name,'/', file_name));
                k = k+1;
%                 if(rem(k,1000) == 0)
%                     pause
%                 end
            end
        end
    end
end