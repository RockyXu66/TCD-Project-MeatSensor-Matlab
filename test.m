clc; clear all; close all;

methods = ['HSB';'Lab';'XYZ'];
methods = cellstr(methods);
k = 1; % method used
chan = 1; %
chan2 = 1;
neigh = 5;
thresh = 0.20;
disksize = 3;
im=imread('/Volumes/YINGHANUSB/TCD Project (meatsensor)/Dataset_3/MT3_R-1/000.bmp');
b1 = size(im,2)/3;
b2 = 2*b1;
im = im(:,b1:b2,:);
im = im(495:495+201,235:235+201,:); % 1,2,4,6
[im2,im3,a,a2,a3]=nocropfunc(im,1,1,neigh,thresh,disksize,100,methods{k});


figure(1);
imshow(im, []);
title('MT3_R-1/000.bmp');
% figure();
% imshow(

% im = im(495:495+201,190:190+201,:); % 190 for 3
% im = im(495:495+201,215:215+201,:); % 215 for 5
% im = im(495:495+201,235:235+201,:); % 1, 2, 4, 6

% im=imread('Dataset_3\MT2_L-3\100.bmp');
% b1 = size(im,2)/3;
% b2 = 2*b1;
% im = im(:,b1:b2,:);
% pos = [235 495 ;235 696 ;436 495 ;436 696 ];
% im = insertMarker(im,pos,'x','color','green','size',10);
% figure(2); imshow(im, []); title('MT2_L-3\100.bmp');
% 
% 
% im=imread('Dataset_3\MT2_R-4\100.bmp');
% b1 = size(im,2)/3;
% b2 = 2*b1;
% im = im(:,b1:b2,:);
% pos = [235 495 ;235 696 ;436 495 ;436 696 ];
% im = insertMarker(im,pos,'x','color','green','size',10);
% figure(3); imshow(im, []); title('MT2_R-4\100.bmp');
% 
% 
% im=imread('Dataset_3\MT3_CS-01\100.bmp');
% b1 = size(im,2)/3;
% b2 = 2*b1;
% im = im(:,b1:b2,:);
% pos = [190 495 ;190 696 ;391 495;391 696];
% im = insertMarker(im,pos,'x','color','green','size',10);
% figure(4); imshow(im, []); title('MT3_CS-01\100.bmp');
% 
% 
% im=imread('Dataset_3\MT3_R-1\100.bmp');
% b1 = size(im,2)/3;
% b2 = 2*b1;
% im = im(:,b1:b2,:);
% pos = [235 495 ;235 696 ;436 495 ;436 696 ];
% im = insertMarker(im,pos,'x','color','green','size',10);
% figure(5); imshow(im, []); title('MT3_R-1\100.bmp');
% 
% 
% im=imread('Dataset_3\MT3_R-2\100.bmp');
% b1 = size(im,2)/3;
% b2 = 2*b1;
% im = im(:,b1:b2,:);
% % im = im(495:495+201,215:215+201,:);
% pos = [215 495;215 696;416 495;416 696];
% im = insertMarker(im,pos,'x','color','green','size',10);
% figure(6); imshow(im, []); title('MT3_R-2\100.bmp');
% 
% 
% im=imread('Dataset_3\MT3_R-3\100.bmp');
% b1 = size(im,2)/3;
% b2 = 2*b1;
% im = im(:,b1:b2,:);
% pos = [235 495 ;235 696 ;436 495 ;436 696 ];
% im = insertMarker(im,pos,'x','color','green','size',10);
% figure(7); imshow(im, []); title('MT3_R-3\100.bmp');
% 
