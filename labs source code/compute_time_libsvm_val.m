%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

function t = compute_time_libsvm_val(libsvmValRunningTime)
t1 = libsvmValRunningTime.validationTimeSavingFirstStep;
t2 = libsvmValRunningTime.learningTimePerClass;
t3 = libsvmValRunningTime.validationTimePerClass;
t4 = libsvmValRunningTime.validationTimePerSvmConfig;
t5 = libsvmValRunningTime.validationTimeSavingLastStep;
temp_t2 = 0;
temp_t3 = 0;
for i = 1:10
    temp_t2 = temp_t2 + sum(sum(t2(:,:,i)));
    temp_t3 = temp_t3 + sum(sum(t3(:,:,i)));
end 
t = t1 + temp_t2 + temp_t3 + sum(sum(t4)) + t5;
end