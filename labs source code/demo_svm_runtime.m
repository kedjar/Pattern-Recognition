%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

g_e = -4:-1;
C_e = 0:4;
g = 10.^(g_e);
C = 10.^(C_e);

   for i = 1:numel(g)        
        for j = 1:numel(C) 
            gc(i,j) = 0;
        end
   end
   
   a = svmValRunningTime.validationTimePerClass;
   t = 0;
   for i = 1:10
       t = t + sum(sum(a(:,:,i)));
   end
   t
   u = sum(sum(svmValRunningTime.validationTimePerSvmConfig));
   v = svmValRunningTime.validationTimeSavingFirstStep+svmValRunningTime.validationTimeSavingLastStep;
   
   t+u+v;