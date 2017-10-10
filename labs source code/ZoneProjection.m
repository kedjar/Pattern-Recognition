%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

function [database] = ZoneProjection(image,m,n,mz,nz)

% Calcul of the required parameters
zr = round(m/mz);
zc = round(n/nz);
% Resize the image
img = imresize(image , [m  n]);
% Convert to binary image
img(img >= 0.5) = 1;
img(img < 0.5) = 0;

zone = zeros(zr , zc);

for ii = 1:zr
    index_r = mz*(ii-1)+1 : mz*ii;
    for jj = 1:zc
        index_c = nz*(jj-1)+1 : nz*jj;             
        temp = img(index_r , index_c);
        zone(ii,jj) = mean(sum(temp,1));
    end
end

zone_r = mean(zone,1);      % Row mean vector 
zone_c = mean(zone,2);      % Column mean vector 

database = [reshape(zone, zr*zc,1) ; zone_r'; zone_c];   % Final feature vector 
end