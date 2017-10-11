%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

function [y, list_images] = get_list_images(path)
    list_images = {};
    count_images = 0;
	folder = list_files(path);
	y = [];
	names = {};
	n = 1;
	for i=1:length(folder)
		subject = folder{i};
		images = list_files([path, filesep, subject]);
		if(length(images) == 0)
			continue; %% dismiss files or empty folder
        end   
		added = 0;
		names{n} = subject;
		%% build image matrix and class vector
		for j=1:length(images)
			%% absolute path
			filename = [path, filesep, subject, filesep, images{j}]; 
			%% Octave crashes on reading non image files (uncomment this to be a bit more robust)
			temp_file = strsplit(images{j}, '.');
            extension = temp_file{end};
			if(~any(strcmpi(extension, {'pgm', 'bmp', 'gif', 'jpg', 'jpeg', 'png', 'tiff'})))
				continue;
            end
      
			% Quite a pythonic way to handle failure.... May blow you up just like the above.
			try
				T = double(imread(filename));
                
			catch
				lerr = lasterror;
				fprintf(1,'Cannot read image %s', filename)
			end
			count_images = count_images+1;
            list_images{count_images} = filename;      
			%% finally try to append data
			try				
				y = [y, n];
				added = added + 1;
			catch
				lerr = lasterror;
				fprintf(1,'Image cannot be added to the Array. Wrong image size?\n')
			end
		end
		% only increment class if images were actually added!
		if ~(added == 0)
			n = n + 1;
		end
	end
end
