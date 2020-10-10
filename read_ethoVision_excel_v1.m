

clear all
close all
clc


%% 

% Opto videos are all 30 FPS?

% 4 spaces for 2 digit numbers, 5 spaces for 1 digit numbers

for pp = 1:52

    
[num,txt,raw] = xlsread(['Raw data-christian opto motor openfield BIGRUN1-Trial    ',num2str(pp)]);

frameCnt = size(num,1);

timeMat = num(2:frameCnt,1);
velMat = num(2:frameCnt,9);

save(['veloData_',num2str(pp),'_.mat'],'timeMat','velMat')


end
