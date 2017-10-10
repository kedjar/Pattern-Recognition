%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

function [database , labels] = get_features(chooseDatabase, noise_variance)  
choosePattern = [100 80; % Different configurations to be tested
                 10  10 ];

% chooseDatabase: Database choice: 1 (Learning), 2 (Test)
switch chooseDatabase
    case 1,
        path = '..\data\mnist7000\Learning\';  % Path to the learning database
        nb_ex_class = 600;                    % Number of samples per class
        %saveFilename = 'pZone_training_';        
    case 2,
        path = '..\data\mnist7000\Test\';      % Path to the test database
        nb_ex_class = 100;                    % Number of samples per class
        %saveFilename = 'pZone_testing_';       
    otherwise,
        error('Wrong choice');
end
n_Config = 1; 

for k = 1:n_Config
    m  = choosePattern(1 , 1 + 2*(k-1));    % Width of the image
    n  = choosePattern(1 , 2 + 2*(k-1));    % Height of the image
    mz = choosePattern(2 , 1 + 2*(k-1));    % Width of the zone
    nz = choosePattern(2 , 2 + 2*(k-1));    % Height of the zone
    zr = round(m / mz);                     % Number of zones in the horizontal direction
    zc = round(n / nz);                     % Number of zones in the vertical direction
    
    d = zr * zc + zr + zc;                  % Feature vector dimension
    database = zeros(nb_ex_class*10,d);     % Feature vector coordinates
    labels = zeros(nb_ex_class*10,1);       % Feature vector labels
    
    % Main loop
    for i = 1:10       
        fid = fopen([path 'listing_' num2str(i-1) '.txt'],'r');
        for j = 1:nb_ex_class
            tline = fgetl(fid);
            image = imread([path num2str(i-1) '/' tline]);
            noised_image = AddNoiseToBWImage(image,noise_variance);
            %figure, imagesc(noised_image)
            database(nb_ex_class*(i-1)+j,:) = ZoneProjection(noised_image,m,n,mz,nz);
            labels(nb_ex_class*(i-1)+j) = i;
        end
        fclose(fid);       
    end   
end
end