%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

function correct_luminance(face_db_main_path, face_db_new_path,  classes, classNumber, params)

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
        img_in = double(imread( image_path ))/255;    
        img_l = lrt( img_in, params(1), params(2), params(3) );
        img_l_path = strcat(face_db_new_path, '\', pathstr_split{end},'\',name,'_l',ext);        
        imwrite(img_l,img_l_path,image_info.Format);
    end
end
end