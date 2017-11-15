function whiskerangle_bin(filename)
%filename = '150831_file-0.mat';
%filename = fname2;
load(filename)

binSize = 20; %number of frames per bin
i = 1;
a = 1;

while i <= length(whiskerPosition_median) - binSize
    whiskerPosition_binned(a) = nanmean(whiskerPosition(i:i+binSize));
    whiskerPosition_median_binned(a) = nanmean(whiskerPosition_median(i:i+binSize));
    i = i + binSize;
    a = a+1;
    
end

whiskerPosition_var = zeros(size(whiskerPosition));
for i = 1:length(whiskerPosition_median) - binSize
    whiskerPosition_var(i) = nanvar(whiskerPosition_median(i:i+binSize));
end

whiskerPosition_varSR = sqrt(whiskerPosition_var);
whiskerPosition_smoothed = smoothData(whiskerPosition_median,20);

%whiskerPosition_median = whiskerPosition_median;
whiskerPosition_median(isnan(whiskerPosition_median)) = nanmean(whiskerPosition_median);
whiskerPositionFilt = filterData(whiskerPosition_median,[0.001 5],125);

% for i = 1:length(IRLedStartFrames)
%     %avgeyeLum(IRLedStartFrames(i)-6:IRLedStartFrames(i)+1) = nanmean(avgeyeLum(IRLedStartFrames(i)-20:IRLedStartFrames(i)-10));
%     %pupilSize(IRLedStartFrames(i)-6:IRLedStartFrames(i)+1) = nanmean(pupilSize(IRLedStartFrames(i)-20:IRLedStartFrames(i)-10));
%     whiskerPosition_varSR(IRLedStartFrames(i)-6:IRLedStartFrames(i)+1) = nanmean(whiskerPosition_varSR(IRLedStartFrames(i)-20:IRLedStartFrames(i)-10));
%     whiskerPosition_median(IRLedStartFrames(i)-6:IRLedStartFrames(i)+1) = nanmean(whiskerPosition_median(IRLedStartFrames(i)-20:IRLedStartFrames(i)-10));
%     whiskerPositionFilt(IRLedStartFrames(i)-6:IRLedStartFrames(i)+1) = nanmean(whiskerPositionFilt(IRLedStartFrames(i)-20:IRLedStartFrames(i)-10));
%     whiskerPosition_smoothed(IRLedStartFrames(i)-6:IRLedStartFrames(i)+1) = nanmean(whiskerPosition_smoothed(IRLedStartFrames(i)-20:IRLedStartFrames(i)-10));
% 
% end
save(filename,'whiskerPosition_median_binned','whiskerPosition_var','whiskerPosition_varSR','whiskerPosition_smoothed',...
    'whiskerPositionFilt','-append')

figure(1)
ax(1) = subplot(4,1,1);
plot(whiskerPosition_median,'-b')
axis tight
ylabel('Median whisker angle per frame (deg)')

ax(2) = subplot(4,1,2);
%plot(whiskerCurvature,'-c')
plot(whiskerPosition_smoothed,'-c')
axis tight
title('Smoothed whisker angle')

ax(3) = subplot(4,1,3);
hold on
plot(whiskerPositionFilt,'-m')
%plot(whiskerPosition_var,'-m')
%ylabel('Mean whisker position per frame (deg)')
axis tight
title('Low-pass filtered whisker angle')

ax(4) = subplot(4,1,4);
hold on
plot(sqrt(whiskerPosition_var),'-g')
%ylabel('Mean whisker position per frame (deg)')
axis tight
title('sqrt(variance) of whisker angle')

linkaxes(ax,'x')

figure(2)
subplot(3,1,1)
hist(whiskerPosition_median,50)
h = findobj(gca,'Type','patch');
set(h,'FaceColor','b','EdgeColor','w')
axis tight
title('histogram of median whisker angle')

subplot(3,1,2)
hist(whiskerPosition_var,50)
h = findobj(gca,'Type','patch');
set(h,'FaceColor','m','EdgeColor','w')
axis tight
title('histogram of variance of whisker angle')

subplot(3,1,3)
hist(sqrt(whiskerPosition_var),50)
h = findobj(gca,'Type','patch');
set(h,'FaceColor','g','EdgeColor','w')
axis tight
title('histogram of sqrt(variance) of whisker angle')

end
