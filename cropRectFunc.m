function [rect] = cropRectFunc(xval,yval,ExtendCoor)
 
% ExtendCoor=100;
% The bounded box is reconstructured from the centroid

blx=xval-ExtendCoor(1);
bly=yval-ExtendCoor(2);

blm=[blx bly];

brx=xval+ExtendCoor(1);
bry=yval-ExtendCoor(2);

brm=[brx bry];

tlx=xval-ExtendCoor(1);
tly=yval+ExtendCoor(2);

tlm=[tlx tly];

trx=xval+ExtendCoor(1);
tryy=yval-ExtendCoor(2);

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