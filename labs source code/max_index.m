%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

function [index , maxindex] = max_index(vector)
    index = zeros(10,1);
    for ii=1:10
       index(ii) = length(find(vector == ii));        
    end
    [~,maxindex] = max(index);
end