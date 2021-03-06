% %% TCD Meat Sensor
% 1. Import images and corresponding O2 values from .xlsx file 
% 2. Crop ROI automatically and calculate mean hue
% 3. Use O2 value and corresponding Q (hue value) to find curve
% 4. Save parameters for curve 

clear all; close all; clc
format short g

%% 
% Specific folder name. This folder contains the images and .xlsx file
% which contains corresponding O2 values.

foldername = 'D:/TCD Project (meatsensor)/Yinghan/MT3_R-1';
O2_filename = 'MT3_R-1_O2 - Copy.xlsx';
% foldername = 'MT2_L-3';
% O2_filename = 'MT2_L-3_O2.xlsx';
index_dataset = 1;

[O2_values, img_names] = xlsread(cat(2, foldername, '/', O2_filename)); 

% RGB image after cropped (ROI)
originalImg = cell(1, 1);

% image after processed (ROI)
outImg = cell(1, 1);

% mean hue value (after hue shifting)
Q = zeros(1, 1);
% median hue value
Q_50 = zeros(1, 1);
Q_75 = zeros(1, 1);
% used to save O2 value
O2 = zeros(1, 1);

% used method 
methods = ['HSB';'Lab';'XYZ'];
methods = cellstr(methods);

%% Setting parameters 
chan = 1; %
chan2 = 1;
neigh = 5;
% threshold = 0.25;
threshold = 0.25;
disksize = 3;  
index_method = 1;   % 'HSB'
extendRatio = 0.2;  % ratio of roi area to whole bounding box area
% extendCoor = 100;   % 1/2 width of the rectangle (roi)

%% Delete '.' files in 'Images' folder
pathf = cat(2,foldername, '/Images/');
files = dir(fullfile([pathf '*.bmp']));
filessize = numel(files);
for i=1:1:filessize
    if(strcmp(files(i).name(1),'.'))
        delete([pathf files(i).name]); 
    end
end

%% Import images path (The default images folder should be "Images" which should be inside the foldername folder)
% data = Datasets{index_dataset};
files = dir(fullfile([pathf '*.bmp']));
filessize = numel(files);

% newpathf = 'D:/TCD Project (meatsensor)/Yinghan/Dataset_3_copy/MT3_R-1-Noise_0.005/Images/';

%% Process images
% for file_index = 1:1:filessize
%     % Print file path
%     sprintf('%s',cat(2,pathf,files(file_index).name))
%     
%     % Read image from file
%     im=imread([pathf files(file_index).name]);
%     
% %     % Add noise and save
% %     noise_im = imnoise(im,'salt & pepper', 0.005);
% %     imwrite(noise_im, cat(2,newpathf,files(file_index).name));
%     
%     % Crop image to center part (3/5 width of original image)
%     im = im(:, size(im,2)/5:4*(size(im,2)/5), :);  
% 
% %     [im] = findCenterFunc(im, neigh, disksize, threshold, extendCoor);
%     [im] = findCenterFunc(im, neigh, disksize, threshold, extendRatio, file_index);
% 
%     [originalImg{file_index},outImg{file_index},Q(file_index),Q_50(file_index),Q_75(file_index)]=...
%     computeQFunc(im, methods{index_method}, chan2);
% 
% %         figure();
% %         imshow(out{file_index});
% %         disp(Q(file_index));
% 
% %     else
% %         [orr{file_index},out{file_index},a,a2,a3]=...
% %             processfunc(im,chan,chan2,neigh,thresh,disksize,100,methods{index_method});
% end
count = 1;
for i = 1:1:numel(img_names)
    % Print file path
    sprintf('%s',cat(2,pathf,char(img_names(i))))
    try 
        im=imread([pathf char(img_names(i))]);% Read image from file
        if ~isempty(im)            
            % Crop image to center part (3/5 width of original image)
            im = im(:, size(im,2)/5:4*(size(im,2)/5), :);  

            % Find the center interested area of the strip
            [im] = findCenterFunc(im, neigh, disksize, threshold, extendRatio, i);

            % Calculate mean hue value (Q) for each image
            [originalImg{count},outImg{count},Q(count),Q_50(count),Q_75(count)]=...
            computeQFunc(im, methods{index_method}, chan2);
            % Save corresponding O2 value
            O2(count) = O2_values(i);
            count = count + 1;
        end
        
    catch
        error([pathf char(img_names(i)) ' not found']);
    end
end


% [f_cubic, stats_cubic] = fit(O2',Q','poly3');
% settings_cubic = [f_cubic.p1 f_cubic.p2 f_cubic.p3 f_cubic.p4];

[settings, sse, f, type] = fitFunc(O2, Q, foldername);

% Save the Q result to _Qresult.mat file
Q_result = cat(2,foldername,'/QResult.mat');
save(Q_result,'O2','Q','Q_50','Q_75');

% Save the curve parameters to _para.mat file
save(cat(2,foldername, '/Para.mat'), 'settings');





































