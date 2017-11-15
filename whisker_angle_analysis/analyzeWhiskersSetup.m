function analyzeWhiskersSetup(filename)

close all
vidfile = [filename(1:end-4) '.mp4'];
%vidfile = [filename(1:end-6) '.mp4'];
disp(vidfile);
disp('Loading video file...')
vidobj = VideoReader(vidfile); %Load the video file

%Get video information
nFrames = vidobj.NumberOfFrames;
vidLength = vidobj.Duration; %length of video in seconds
vidFrameRate = vidobj.FrameRate;
vidHeight = vidobj.Height; %resolution of video
vidWidth = vidobj.Width;
df = 1000/vidFrameRate; %time in msec between video frames

whiskMov(1) = struct('cdata',zeros(vidHeight,vidWidth,'uint8'),...
    'colormap',[]);
whiskMov(1).cdata = read(vidobj,1);

%Manually create the ROI for whiskers 
checkThresh = 0;
while isequal(checkThresh, 0)
    figure(1)
    image(whiskMov(1).cdata)
    hold on
    disp('Upper right XY boundary for whisker quadrant: ');
    [xThresh1,yThresh1] = ginput(1);
    disp('Lower left XY boundary for whisker quadrant: ');
    [xThresh2,yThresh2] = ginput(1);
    %Display first frame with chosen thresholds
    line([xThresh1 xThresh2],[yThresh1 yThresh1])
    line([xThresh1 xThresh1],[yThresh1 yThresh2])
    line([xThresh2 xThresh2],[yThresh1 yThresh2])
    line([xThresh1 xThresh2],[yThresh2 yThresh2])
    checkThresh = input('Does this look correct (0 = no, 1 = yes)? ');
end

%Manually set the edges of the face for determining whisker follicle
%positions
disp('Now set the start and end positions for the side of the face you are analyzing.')
checkThresh = 0;
while isequal(checkThresh, 0)
    figure(1)
    disp('Enter [x y] coordinates for front (near the nose) face edge (e.g. [118,145]): ');
    faceEdgeStart = ginput(1);
    disp('Enter [x y] coordinates for back face edge (e.g. [147,183]): ');
    faceEdgeEnd = ginput(1);
   
    %Display line for edge of face
    [faceEdgeX,faceEdgeY,faceAngle] = calcFaceEdge(faceEdgeStart,faceEdgeEnd);
    plot(faceEdgeX,faceEdgeY,'.y')
    checkThresh = input('Does this look correct (0 = no, 1 = yes)? ');
end

disp('Enter [x y] coordinates for the location of the IR LED light spot: ');
IRledLocation = ginput(1);
IRledLocation = round(IRledLocation);

disp('Saving .mat file...')
save(filename,'nFrames','vidLength','vidFrameRate','vidHeight',...
    'vidWidth','df','xThresh1','yThresh1','xThresh2','yThresh2','faceEdgeX','faceEdgeY','faceAngle',...
    'IRledLocation')
end

function [fX,fY,angle] = calcFaceEdge(fstart,fend)

if (fend(1) - fstart(1)) > (fend(2) - fstart(2))
    dx = 1;
    dy = (fend(2) - fstart(2))/(fend(1) - fstart(1));
else
    dx = (fend(1) - fstart(1))/(fend(2) - fstart(2));
    dy = 1;
end

fX = fstart(1):dx:fend(1);
fY = fstart(2):dy:fend(2);
angle = abs(rad2deg(atan((fend(1) - fstart(1))/(fend(2) - fstart(2)))));

end
