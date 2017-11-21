
function [dataSmoothed] = smoothData(data,binSize,type)

disp('Smoothing data...')

if nargin < 3
    type = 'mean';
end

[x,y]=max(size(data));
if y == 2
    data = data';
end

dataSmoothed = zeros(size(data));

for i = 1:size(dataSmoothed,1)
    
    if i - round(binSize/2) < 1
        binStart = 1;
    else
        binStart = i - round(binSize/2);
    end
    
    binEnd = i + round(binSize/2);
    if binEnd > size(data,1)
        binEnd = size(data,1);
    end
    
    if isequal(type,'max')
        dataSmoothed(i,:) = max(data(binStart:binEnd,:));
    else
        dataSmoothed(i,:) = nanmean(data(binStart:binEnd,:));
    end
end

end
