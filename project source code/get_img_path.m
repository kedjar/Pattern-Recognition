%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

function [p_age , p_gender] = get_img_path(target_age , target_gender, a_folder, g_folder, img_name)

if(strcmp(target_age , '(0, 2)') == 1)
    p_age = 1;
end 
if(strcmp(target_age , '(4, 6)') == 1)
    p_age = 2;
end 
if(strcmp(target_age , '(8, 12)') == 1)
    p_age = 3;
end 
if(strcmp(target_age , '(15, 20)') == 1)
    p_age = 4;
end 
if(strcmp(target_age , '(25, 32)') == 1)
    p_age = 5;
end 
if(strcmp(target_age , '(38, 43)') == 1)
    p_age = 6;
end 
if(strcmp(target_age , '(48, 53)') == 1)
    p_age = 7;
end 
if(strcmp(target_age , '(60, 100)') == 1)
    p_age = 8;
end 

if(    strcmp(target_age , '(0, 2)'   ) == 0 ...
    && strcmp(target_age , '(4, 6)'   ) == 0 ...
    && strcmp(target_age , '(8, 13)'  ) == 0 ...
    && strcmp(target_age , '(15, 20)' ) == 0 ...
    && strcmp(target_age , '(25, 32)' ) == 0 ...
    && strcmp(target_age , '(38, 43)' ) == 0 ...
    && strcmp(target_age , '(48, 53)' ) == 0 ...
    && strcmp(target_age , '(60, 100)') == 0)
    p_age = 0;
end 
% 
% if(strcmp(target_age , 'None') == 1)
%     p_age = 0;
% end 

if(strcmp(target_gender , 'm') == 1)
    p_gender = 1;
end 
if(strcmp(target_gender , 'f') == 1)
    p_gender = 2;
end 
 if(    strcmp(target_gender , 'm') == 0 ...
     && strcmp(target_gender , 'f') == 0)
    p_gender = 0;
 end
%img_split = strsplit(img_name, '.');
p_age = strcat(a_folder, num2str(p_age), '/', img_name); 
p_gender = strcat(g_folder, num2str(p_gender), '/', img_name); 
end