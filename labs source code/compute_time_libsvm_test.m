%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

function t = compute_time_libsvm_test(libsvmTestRunningTime)
t1 = libsvmTestRunningTime(1);
t2 = libsvmTestRunningTime(2);
t3 = libsvmTestRunningTime(3);
t1 = t1{1};
t2 = t2{1};
t3 = t3{1};
temp_t1 = 0;
temp_t2 = 0;
for i = 1:10
    temp_t1 = temp_t1 + sum(sum(t1(:,:,i)));
    temp_t2 = temp_t2 + sum(sum(t2(:,:,i)));
end 
t = temp_t1 + temp_t2 + t3;
end