%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

function [indr1 , indr2] = index_reduce(ind1 , ind2, n_classes , rate)


if(rate > 1)
    rate = rate / 100;
end

if(rate > 100 || rate < 0)
    error('rate should be a postive number less than or equal to 100')
end

I1 = numel(ind1) / n_classes;
I2 = numel(ind2) / n_classes;

indr1 = zeros(numel(ind1) * rate , 1);
indr2 = zeros(numel(ind2) * rate , 1);

for i = 1 : n_classes
    t1 = (1 : I1 * rate) + (i - 1) * I1;
    t2 = (1 : I2 * rate) + (i - 1) * I2;
    
    v1 = (1 : I1 * rate) + (i - 1) * I1 * rate;
    v2 = (1 : I2 * rate) + (i - 1) * I2 * rate;
    
    indr1(v1 , : ) = ind1(t1 , : );
    indr2(v2 , : ) = ind2(t2 , : );    
end



end