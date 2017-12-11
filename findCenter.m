clear all; close all; clc
format short g

% filename = 'C:\Users\Soumyajyoti Maji\Desktop\100_1.bmp';
% filename = 'D:\TCD Project (meatsensor)\Dataset_3\MT3_R-3\100.bmp';
% filename = 'D:\TCD Project (meatsensor)\Dataset_3\MT3_R-2\095.bmp';
% filename = 'D:\TCD Project (meatsensor)\Dataset_3\MT2_L-3\085.bmp';
% filename = 'D:\TCD Project (meatsensor)\Yinghan\Dataset_3_copy\MT2_L-3-HBrightness_50\Images\000.bmp';
filename = 'C:/Users/Soumyajyoti Maji/Desktop/IMG-10042017-163747.bmp';
img = imread(filename);

figure;
imshow(img);
title('original');

img = img(:, size(img,2)/5:4*(size(img,2)/5), :);
% img = img(:, size(img,2)/3:2*(size(img,2)/3), :);

% Add noise
% noiseImg = imnoise(img,'salt & pepper',0.02);
% img = imnoise(img,'gaussian', 0, 0.025);
% noiseImg = imnoise(img,'salt & pepper',0.01);
% figure, imshow(noiseImg), title('noise image');
% 
% % img = wiener2(img,[5 5]);
% img = imgaussfilt(img, 2);
% figure, imshow(img), title('noise-removed image');

originalImg = img;
neigh = 5;
disksize = 3;
% threshold = 0.25;
threshold = 0.66;
extendRatio = 0.3;
% extendCoor = 100;

% [croppedImg] = findCenterFunc(img, neigh, disksize, threshold, extendCoor);
% 
% figure;
% imshow(croppedImg);
% title('cropped');

Red = img(:,:,1);
fil1=medfilt2(Red,[neigh neigh]);% Applying the median filter

figure;
imshow(fil1);
title('filter');

% Removing any circular holes
rr=imbinarize(fil1,threshold);
str2=strel('disk',disksize);
f=imfill(imopen(rr,str2),'holes');
figure;
imshow(f);
title('after removing circle');

% img = rgb2gray(img);
% % BW = imbinarize(img, 'adaptive');
% % BW = imbinarize(img, 'global');
% BW = imbinarize(img, threshold);
% figure;
% imshow(BW);
% title('binary image');
% 
% % rr=im2bw(fil1,threshold);
% str2=strel('disk',disksize);
% f=imfill(imopen(BW,str2),'holes');
% figure;
% imshow(f);
% title('after removing circle');
% 
% Removing connected component image outside the strip using image
% morphology
% Find the largest object in an image and the  remove any other that are
% smaller than this
cc=bwconncomp(f);
numPixels=cellfun(@numel,cc.PixelIdxList);
[biggestSize,idx]=max(numPixels);
bw=false(size(f));
bw(cc.PixelIdxList{idx}) = true;

figure;
imshow(bw);

% Finding the rectangular bounding box
stats=[regionprops(bw)];

% Finding out the centroid of the bounding box
centroids = stats.Centroid;
boundingBox = stats.BoundingBox;
newCentroids = [boundingBox(1)+boundingBox(3)/2, boundingBox(2)+boundingBox(4)/2];
% boundingBox = int16(boundingBox);

% % % xy1 = [boundingBox(1),boundingBox(2)];
% % % xy2 = [boundingBox(3), boundingBox(4)];
% % % pt1 = (xy1+xy2)/2;
% % % wSize1 = [xy2(1)-pt1(1), xy2(2)-pt1(2)];
% % % % % % boundingImg = drawRect_2(originalImg, [boundingBox(1),boundingBox(2)], [boundingBox(3), boundingBox(4)], 5);
% % % % % % figure;
% % % % % % imshow(boundingImg);

% After applying all the filtering techniques, original image is
% reconstructed


% testing find, probably faster
% orr(:,:,1)=immultiply(img(:,:,1),bw);
% orr(:,:,2)=immultiply(img(:,:,2),bw);
% orr(:,:,3)=immultiply(img(:,:,3),bw);

% Cropped roi to center square
% extendCoor = sqrt(extendRatio * stats.Area)/2;
% [rect] = cropfunction(centroids(:,1),centroids(:,2),extendCoor);

% Cropped roi to center rectangle
x = boundingBox(3);
y = boundingBox(4);
[extendCoor_rect] = [sqrt(extendRatio * stats.Area * x / y) / 2, sqrt(extendRatio * stats.Area * y / x) / 2];
[rect] = cropRectFunc(centroids(:,1), centroids(:,2), extendCoor_rect);


figure;
imshow(originalImg);
hold on;
% Then, from the help:
rectangle('Position',boundingBox, 'EdgeColor','g', 'LineWidth',2);
hold on;
rectangle('Position', rect, 'EdgeColor', 'g', 'LineWidth', 2);
hold on; 
plot(centroids(:,1),centroids(:,2), 'g*');
hold off;

% % Edge detection
% bw1 = edge(img,'sobel', 0.1);
% bw1 = edge(img, 'canny', 0.15);
% 
% figure;
% imshow(bw1);
% title('edges');













