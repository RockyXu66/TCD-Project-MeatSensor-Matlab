% function[croppedImg] = findCenterFunc(img, neigh, disksize, threshold, extendCoor)
function[croppedImg] = findCenterFunc(img, neigh, disksize, threshold, extendRatio, file_index)
% calculate ROI by using filter, threshold, removing circular holes,
% connected component and find the largest object
originalImg = img;

Red = img(:,:,1);
fil1=medfilt2(Red,[neigh neigh]);% Applying the median filter

% figure;
% imshow(fil1);
% title('filter');

% Removing any circular holes
rr=im2bw(fil1,threshold);
str2=strel('disk',disksize);
f=imfill(imopen(rr,str2),'holes');
% figure;
% imshow(f);
% title('after removing circle');

% img = rgb2gray(img);
% 
% BW = imbinarize(img, threshold);
% 
% % rr=im2bw(fil1,threshold);
% str2=strel('disk',disksize);
% f=imfill(imopen(BW,str2),'holes');

% Removing connected component image outside the strip using image
% morphology
% Find the largest object in an image and the  remove any other that are
% smaller than this
cc=bwconncomp(f);
numPixels=cellfun(@numel,cc.PixelIdxList);
[biggestSize,idx]=max(numPixels);
bw=false(size(f));
bw(cc.PixelIdxList{idx}) = true;

% Finding the rectangular bounding box
stats=[regionprops(bw)];

% Finding out the centroid of the bounding box
% centroids=stats.Centroid;
boundingBox = stats.BoundingBox;
centroids = [boundingBox(1)+boundingBox(3)/2, boundingBox(2)+boundingBox(4)/2];
% After applying all the filtering techniques, original image is
% reconstructed


% testing find, probably faster
% orr(:,:,1)=immultiply(img(:,:,1),bw);
% orr(:,:,2)=immultiply(img(:,:,2),bw);
% orr(:,:,3)=immultiply(img(:,:,3),bw);

% Cropped roi to center square
% extendCoor = int16(sqrt(extendRatio * stats.Area)/2);
% [rect] = cropfunction(centroids(:,1),centroids(:,2),extendCoor);

% Cropped roi to center rectangle
x = boundingBox(3);
y = boundingBox(4);
[extendCoor_rect] = [int16(sqrt(extendRatio * stats.Area * x / y) / 2), int16(sqrt(extendRatio * stats.Area * y / x) / 2)];
[rect] = cropRectFunc(centroids(:,1), centroids(:,2), extendCoor_rect);

isDraw = (file_index==1||file_index==5||file_index==11||file_index==21||file_index==31||file_index>38);
isDraw = false;
if isDraw
    figure;
    hold on;
    imshow(originalImg);
    hold on;
    % Then, from the help:
    rectangle('Position',boundingBox, 'EdgeColor','g', 'LineWidth',2);
    hold on;
    rectangle('Position', rect, 'EdgeColor', 'g', 'LineWidth', 2);
    hold on;
    plot(centroids(:,1),centroids(:,2), 'g*');
    hold off;
end


croppedImg = imcrop(originalImg, rect);

% Edge detection
% bw1 = edge(img,'sobel', 0.1);
% bw1 = edge(img, 'canny', 0.15);

% figure;
% imshow(bw1);
% title('edges');

end













