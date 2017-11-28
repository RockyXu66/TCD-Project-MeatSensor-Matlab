%% TCD Meat Sensor
% 1. Import images and corresponding O2 values from .xlsx file 
% 2. Crop ROI and calculate mean hue
% 3. Use O2 value and corresponding Q (hue value) to find curve
% 4. Save parameters for curve 

clear all; close all; clc
format short g

%% 
% Specific folder name. This folder contains the images and .xlsx file
% which contains corresponding O2 values.
% The result will also be saved in this folder
% prompt = 'Please type in the folder name:';
% % x = input(prompt)
% y = x*10
foldername = 'MT2_L-3';
O2_filename = 'MT2_L-3_O2.xlsx';
index_dataset = 1;

O2 = xlsread(cat(2, foldername, '/', O2_filename)); 

% RGB image after cropped (ROI)
originalImg = cell(1, 1);

% image after processed (ROI)
outImg = cell(1, 1);

% mean hue value (after hue shifting)
Q = zeros(1, 1);
% median hue value
Q_50 = zeros(1, 1);
Q_75 = zeros(1, 1);

% used method
methods = ['HSB';'Lab';'XYZ'];
methods = cellstr(methods);

%% Setting parameters 
chan = 1; %
chan2 = 1;
neigh = 5;
threshold = 0.23;
disksize = 3;  
index_method = 1;   % 'HSB'
extendCoor = 100;   % 1/2 width of the rectangle (roi)

%% Delete '.' files in 'Images' folder
pathf = cat(2,foldername, '/Images/');
files = dir(fullfile([pathf '*.bmp']));
filessize = numel(files);
for i=1:1:filessize
        if(strcmp(files(i).name(1),'.'))
            delete([pathf files(i).name]); 
        end
end

%% Import images path (The default images folder should be "Image" which should be inside the foldername folder)
% data = Datasets{index_dataset};
files = dir(fullfile([pathf '*.bmp']));
filessize = numel(files);

%% Process images
for file_index = 1:1:filessize
    % Print file path
    sprintf('%s',cat(2,pathf,files(file_index).name))
    
    % Read image from file
    im=imread([pathf files(file_index).name]);
    
    % Crop image to center part (3/5 width of original image)
%     im = im(:, size(im,2)/5:4*(size(im,2)/5), :);
    im = im(:, size(im,2)/3:2*(size(im,2)/3), :);
    
    % Need to be improved
    if (index_dataset == 3)
        im = im(495:495+201,190:190+201,:); % 190 for 3
    elseif (index_dataset == 5)
        im = im(495:495+201,215:215+201,:); % 215 for 5
    else
        im = im(495:495+201,235:235+201,:); % 1, 2, 4, 6
    end

%         print value in command line
%         disp("test: "+size(im,1));
%         show cropped image
%         figure();
%         imshow(im);

%     [originalImg{file_index},outImg{file_index},Q(file_index),Q_50(file_index),Q_75(file_index)]=...
%         nocropfunc(im,chan,chan2,neigh,thresh,disksize,extendCoor,methods{index_method});

%         [im] = findCenterFunc(im, neigh, disksize, threshold, extendCoor);
        
    figure;
    imshow(im);

    [originalImg{file_index},outImg{file_index},Q(file_index),Q_50(file_index),Q_75(file_index)]=...
    computeQFunc(im, methods{index_method}, chan2);

%         figure();
%         imshow(out{file_index});
%         disp(Q(file_index));

%     else
%         [orr{file_index},out{file_index},a,a2,a3]=...
%             processfunc(im,chan,chan2,neigh,thresh,disksize,100,methods{index_method});
end

%% calculate curve
avg = Q;
med = Q_50;
[settings,errors,f,plotv] = fitandimport(O2,avg','exp2');

% Draw the result
figure();
plot(O2,avg,'b');
hold on
plot(O2,med,'r');
hold on
plot(O2,f(settings(1),settings(2),settings(3),settings(4),O2),'g'); 
% title2 = sprintf('%s %s-%d-%d',Datasets{k1},methods{k2},k3,k4); % testing
title(foldername);
legend('avg','med','fit');
hold off

drawnow
titleFit = sprintf(' a = %.4g,b = %.4g,c = %.4g,d = %.4g',...
    settings(1),settings(2),settings(3),settings(4));
% title1 = cat(2,title2,titleFit)

%% Save the curve parameters to the .txt file
fid=fopen(cat(2, foldername, '/parameters.txt'),'w');
fprintf(fid,'a = %f \n',settings(1));
fprintf(fid,'b = %f \n',settings(2));
fprintf(fid,'c = %f \n',settings(3));
fprintf(fid,'d = %f \n',settings(4));
fclose(fid);

% Save the Q result to _Qresult.mat file
Q_result = cat(2,foldername,'/',foldername,'_Qresult.mat');
save(Q_result,'O2','Q','Q_50','Q_75');

% Save the curve parameters to _para.mat file
save(cat(2,foldername, '/', foldername, '_para.mat'), 'settings');





































