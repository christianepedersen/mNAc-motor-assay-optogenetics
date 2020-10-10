% Analyze opto effects on locomotion - mNAc project
% Code by Christian Pedersen

clear all
close all
clc

%% load velocity timeseries for each session
%  take time of first laser onset
%  only consider 14 mins after first laser onset
%  need to interpolate the data and take median per second?
%  compare 30s of stim to 30s no stim


% 14 min session starts at first laser onset (0-30s in video)
startDelay(1) =   8.3; % 469R   % in seconds
startDelay(2) =   1.2; % 469L
startDelay(3) =   4.6; % 469B
startDelay(4) =   19.2; % 469DR
startDelay(5) =   4.9; % 469DL
startDelay(6) =   6.4; % 480R
startDelay(7) =   25.4; % 480L
startDelay(8) =   21.3; % 480B
startDelay(9) =   26.1; % 612L
startDelay(10) =   20.9; %612B
startDelay(11) =   7.9; %612DR
startDelay(12) =   10.5; %612DL
startDelay(13) =   11.2; %607N
startDelay(14) =   13.2; %607R
startDelay(15) =   9.0; %607L
startDelay(16) =  3.6;  %905N
startDelay(17) =  12.0;  %590N
startDelay(18) =   2.8; %905B
startDelay(19) =   15.1; %590B
startDelay(20) =   12.4; %363R
startDelay(21) =   21.5; %363B
startDelay(22) =   13.2; %363DR
startDelay(23) =   3.3; %363DL
startDelay(24) =   25.6; %481DR
startDelay(25) =   11.3; %481DL
startDelay(26) =   5.2; %723R
startDelay(27) =   10.7; %723L
startDelay(28) =   6.5; %723B
startDelay(29) =   27.7; %723DR
startDelay(30) =   20.1; %723DL
startDelay(31) =   26.7; %705R
startDelay(32) =   18.1; %705L
startDelay(33) =   5.0; %705B
startDelay(34) =   22.0; %705DR
startDelay(35) =   5.1; %643N
startDelay(36) =   4.5; %643R
startDelay(37) =   19.3; %643L
startDelay(38) =   20.3; %643B
startDelay(39) =   24.3; %643DR
startDelay(40) =   21.3; %724L
startDelay(41) =   22.8; %724B
startDelay(42) =   17.7; %724DL
startDelay(43) =   15.5; %725N
startDelay(44) =   19.8; %725R
startDelay(45) =   13.8; %725L
startDelay(46) =   17.4; %725B
startDelay(47) =   21.3; %1068N
startDelay(48) =   13.1; %1068R
startDelay(49) =   7.9; %1068L
startDelay(50) =   22.3; %726R
startDelay(51) =   7.7; %726DR
startDelay(52) =   21.8; %748B

% enkChR2cre  = [1 3 4 5 7 8 9 10 11];
% enkPPOcre   = [31 32 33 34 50 51 52];
% dynChR2cre  = [20 22 24 26 27 28 29 30];
% dynPPOcre   = [40 41 42 43 44 45 46];
% enkChR2ctrl = [2 6 12 13 14 15];
% enkPPOctrl  = [35 36 37 38 39];
% dynChR2ctrl = [21 23 25 16 18];
% dynPPOctrl  = [17 19 47 48 49];

kk = 1;

for sess = 1:52
    
    load(['veloData_',num2str(sess),'_.mat'])
        
    frameDelay = round(startDelay(sess)*30);
    
    % 14 mins of frames = 25200 frames
    subTime = timeMat(frameDelay+1:frameDelay+25200);
    subVel = velMat(frameDelay+1:frameDelay+25200);
    
    
    % interpolate subVel
    goodFrames = subTime(isnan(subVel)==0);
    badFrames = subTime(isnan(subVel)==1);
    goodVel = subVel(isnan(subVel)==0);
    
    interpVel = interp1(goodFrames,goodVel,badFrames);
    subVel(isnan(subVel)==1) = interpVel;
    
    % resample to 2 measurement a second (by median; ignore extreme values)
    %resampVel = resample(subVel,1,30);
    reVel = reshape(subVel,size(subVel,1)/15,15);
    mediVel = median(reVel,2);
    
    % plot 14 minute time series
    %figure()
    %resampVel = resample(mediVel,1,3);
    %plot(linspace(0,14,length(resampVel)),resampVel)
    %ylim([0 16])
    %xlim([1 9])
    %print -painters -depsc repSpeedSeries.eps
    
    % compare laser epochs to no-laser epochs
    epochVel = reshape(mediVel,60,28); % 28x 30s epochs
    epochAVG = mean(epochVel,1);
    
    % plot epoch progression by class
    %figure()
    %plot(1:14,epochAVG(1:2:end),'',1:14,epochAVG(2:2:end),'');
    %legend('laser','off')
    
    epochz(kk,1:28) = epochAVG;
    
    lazerAVG(kk) = mean(epochAVG(1:2:end));
    nolazAVG(kk) = mean(epochAVG(2:2:end));
    
    kk = kk + 1;
    
end


%% combine data from different sessions

nolazAVG'

lazerAVG'



%% plot mean speed over time for each condition

enkCHR2 = mean(epochz([1 3 4 5 7 8 9 10 11],:),1);
enkPPO  = mean(epochz([31 32 33 34 50 51 52],:),1);
dynCHR2 = mean(epochz([20 22 24 26 27 28 29 30],:),1);
dynPPO  = mean(epochz([40 41 42 43 44 45 46],:),1);
ctrls   = mean(epochz([2 6 12 13 14 15, 35 36 37 38 39, ...
                21 23 25 16 18, 17 19 47 48 49],:),1);


figure()
plot(linspace(0,14,28),ctrls,'k',...
     linspace(0,14,28),enkCHR2,'',...
     linspace(0,14,28),enkPPO,'',...
     linspace(0,14,28),dynCHR2,'',...
     linspace(0,14,28),dynPPO,'')
legend('ctrl','eC','eP','dC','dP')
ylim([0 10])


%print -painters -depsc speedOverSession.eps







