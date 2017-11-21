
function dataFilt = filterData(data,cutoffFreq,samplingRate)

%%%% INPUTS: %%%%%
% data: vector of data points to filter
% cutoffFreq: in Hz, cutoff value(s) for filter design. Usually i enter
% this as a two element vector for a bandpass filter (e.g. [0.1 10])
% samplingRate: sampling freqency of 'data'


%Interpolate NaN values before filtering
%F = fillmissing(pupilDiameter,'linear'); %-> don't have this function in matlab 2015; will do it 'manually' instead
xData = data;
x = 1:length(xData);
xi = find(~isnan(xData));
yi = xData(xi);
xData_new=interp1(xi,yi,x,'linear');
if sum(isnan(xData_new)) ~= 0
    xData_new(isnan(xData_new)) = nanmean(xData_new);
end

%%Band-pass filtering using butterworth filter, then use zero-phase
%%filtering with filtfilt

disp('Filtering data...')

samplingRate = samplingRate/2;
cfreq = cutoffFreq/samplingRate;
if numel(cfreq) == 1
    [b,a] = butter(1,[cfreq],'low'); %change to 'high' or 'low' if necessary
else
    [b,a] = butter(1,[cfreq],'bandpass'); %change to 'high' or 'low' if necessary
end
dataFilt = filtfilt(b,a,xData_new);

end