%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

function [ind1 , ind2] = index_split(n_samples , n_classes , rate)
% This function splits data in a random way to two subsets.
% The first subset will contain (percentage = rate) of the data
% The second subset will contain the remaining 

if(rate > 1)
    rate = rate / 100;
end

if(rate > 100 || rate < 0)
    error('rate should be a postive number less than or equal to 100')
end
ind1 = zeros( n_samples * rate , 1);
ind2 = zeros(n_samples * (1-rate) , 1);

for i = 1:n_classes
    temp = randperm(n_samples/n_classes) + (i - 1) * (n_samples/n_classes);
    I1 = (i - 1) * (n_samples / n_classes) * rate + 1 : i * (n_samples / n_classes) * rate;
    I2 = (i - 1) * (n_samples / n_classes) * (1 - rate) + 1 : i * (n_samples / n_classes) * (1 - rate);
    ind1(I1) = temp(1 : rate*(n_samples/n_classes));
    ind2(I2) = temp(rate*(n_samples/n_classes) + 1 : n_samples/n_classes);
end
end