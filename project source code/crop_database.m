%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

function crop_database(face_db_main_path, face_db_new_path,  classes, classNumber)

face_db = strcat(face_db_main_path,'\',classes{classNumber});
imgSet = imageSet(face_db , 'recursive');
image_path = imgSet(1).ImageLocation{1};
image_info = imfinfo(image_path);

for i = 1:numel(imgSet)
    mkdir(face_db_new_path,imgSet(i).Description)    
    for j = 1:imgSet(i).Count;
        image_path = imgSet(i).ImageLocation{j};
        [pathstr,name,ext] = fileparts(image_path);
        pathstr_split = strsplit(pathstr,'\');        
        img_c = ObjectDetection(image_path,'HaarCascades\haarcascade_frontalface_alt.mat');       
        img_c_path = strcat(face_db_new_path, '\', pathstr_split{end},'\',name,'_c',ext);        
        imwrite(img_c,img_c_path,image_info.Format);
    end
end

end



%
