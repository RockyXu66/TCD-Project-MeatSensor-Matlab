function [rect] = cropfunction(xval,yval,ExtendCoor)
 
% ExtendCoor=100;
% The bounded box is reconstructured from the centroid

blx=xval-ExtendCoor;
bly=yval-ExtendCoor;

blm=[blx bly];

brx=xval+ExtendCoor;
bry=yval-ExtendCoor;

brm=[brx bry];

tlx=xval-ExtendCoor;
tly=yval+ExtendCoor;

tlm=[tlx tly];

trx=xval+ExtendCoor;
tryy=yval-ExtendCoor;

trm=[trx tryy];

fl=[tlm;trm;blm;brm];

minX = min(fl(:,1));
maxX = max(fl(:,1));
minY = min(fl(:,2));
maxY = max(fl(:,2));

width = (maxX - minX + 1);
height = (maxY - minY + 1);
% The four coordinates of the rectangle
rect = [minX minY width height];

end