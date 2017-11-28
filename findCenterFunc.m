function[croppedImg] = findCenterFunc(img, neigh, disksize, threshold, extendCoor)
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
centroids=stats.Centroid;
boundingBox = stats.BoundingBox;
% After applying all the filtering techniques, original image is
% reconstructed


% testing find, probably faster
% orr(:,:,1)=immultiply(img(:,:,1),bw);
% orr(:,:,2)=immultiply(img(:,:,2),bw);
% orr(:,:,3)=immultiply(img(:,:,3),bw);
[rect] = cropfunction(centroids(:,1),centroids(:,2),extendCoor);



% figure;
% hold on;
% imshow(originalImg);
% hold on;
% % Then, from the help:
% rectangle('Position',boundingBox, 'EdgeColor','g', 'LineWidth',2);
% hold on;
% rectangle('Position', rect, 'EdgeColor', 'g', 'LineWidth', 2);
% hold on;
% plot(centroids(:,1),centroids(:,2), 'g*');
% hold off;


croppedImg = imcrop(originalImg, rect);

% Edge detection
% bw1 = edge(img,'sobel', 0.1);
% bw1 = edge(img, 'canny', 0.15);

% figure;
% imshow(bw1);
% title('edges');

end













