%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

function img_size = mean_size(face_db_main_path,  classes, classNumber)

face_db = strcat(face_db_main_path,'\',classes{classNumber});
imgSet = imageSet(face_db , 'recursive');

img_size = zeros(numel(imgSet) * imgSet(1).Count , 2);
for i = 1:numel(imgSet)
   % mkdir(face_db_new_path,imgSet(i).Description)    
    for j = 1:imgSet(i).Count;
        image_path = imgSet(i).ImageLocation{j};
        I =imread(image_path);
        img_size(j, 1:2) = [size(I,1) size(I,2)];
    end
end
end



%
