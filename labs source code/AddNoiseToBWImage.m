%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% add noise 
function N = AddNoiseToBWImage(u,v) 
% u : input image 
% v : variance of the noise 
i = u; 
x = rand(size(i)); 
d = find(x < v/2); 
i(d) = 0;  
d = find(x >= v/2 & x < v); 
i(d) = 1; 
N = i;