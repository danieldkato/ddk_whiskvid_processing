function var = checkTrace_c(fx,fy,tx,ty,xThresh1,yThresh1,xThresh2,yThresh2,...
    faceEdgeX,faceEdgeY,minFollicleDistance,faceAngle,whiskAngle)

%INPUT:
% fx & fy: x and y positions for follicle point of traced object
% tx & ty: x and y positions for tip point of traced object
% xThresh1,yThresh1,xThresh2,yThresh2: ROI boundaries
% faceEdgeX & faceEdgeY: line for the edge of the face
% minFollicleDistance: distance from the follicle point on the object to closest point on the face
% faceAngle: angle of the mouse's face
% whiskAngle: angle of the traced object

%OUTPUT:
%var = set to 1 (is whisker object) or 0 (not whisker object). Default is
%set to 1, but value is changed to 0 if any of the following criteria are
%not true

var = 1;


% %Checks that at least 2/3 of the traced object is within the chosen
% %quadrant for whiskers.
% if (sum(xp < xThresh2) + sum(xp > xThresh1)) >= (length(xp)/2)
%     var = 0;
% elseif (sum(yp > yThresh2) + sum(yp < yThresh1)) >= length(yp)/2
%     var = 0;
% end

if xThresh1 > xThresh2
    dir = 'right';
else
    dir = 'left';
end

%Determine which way the face is oriented
if yThresh1 > yThresh2
    dir2 = 'up';
else
    dir2 = 'down';
%     if xThresh1 > xThresh2
%         dir = 'right';
%     else
%         dir = 'left';
%     end
end

%Checks if follicle point is within ROI
if isequal(dir2,'down')
    if isequal(dir,'right')
        if (fx > xThresh1) || (fy < yThresh1)
            var = 0;
        end
    else
        if (fx < xThresh1) || (fy < yThresh1)
            var = 0;
        end
    end
else
    if isequal(dir,'right')
        if (fx > xThresh1) || (fy > yThresh1)
            var = 0;
        end
    else
        if (fx < xThresh1) || (fy > yThresh1)
            var = 0;
        end
    end
end

%Sets a minimum length that object has to exceed to be considered a whisker
wlength = sqrt((tx - fx)^2 + (ty - fy)^2); %Length of current traced object

minLength = 20;

if abs(wlength) <= minLength
    var = 0;
end

%Sets a threshold such that the 'follicle' of the traced object has to be x
%distance from the face edge
follicleDistThresh = 80;
if minFollicleDistance > follicleDistThresh
    var = 0;
end

%Set a distance threshold just in the 'y' dimension. this is useful for
%ruling out little hairs on the body that are close to the face in the
%x-direction but far from the face in the y-direction
minYdist = 30;
if min(abs(fy - faceEdgeY)) > minYdist
    var = 0;
end

%Follicle point has to be to the left of the face edge
dist = [];
minDist = [];
dist = [];
for j = 1:size(faceEdgeX,2)
    dist(j) = sqrt((faceEdgeX(j) - fx)^2 + (faceEdgeY(j) - fy)^2);
end

[a,b]=min(dist);
if fx > faceEdgeX(b) && fy > faceEdgeY(b)
    %var = 0;
end

end