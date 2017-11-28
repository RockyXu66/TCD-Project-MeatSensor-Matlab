%% TCD Meat Sensor
% histograms plot :

clear all; close all; clc
format short g

%% Setup :
DatasetMain = ['/Volumes/YINGHANUSB/TCD Project (meatsensor)/Dataset_3/'];
DatasetMain = cellstr(DatasetMain);
Datasets = ['MT2_L-3/  ';'MT2_R-4/  ';'MT3_CS-01/';'MT3_R-1/  ';'MT3_R-2/  ';'MT3_R-3/  '];
% Datasets = ['MT3_R-1/'];
Datasets = cellstr(Datasets);

% air = 20.9;

DatasetO2 = cell(6,1);
DatasetO2{1} = [0,0,5,5,10,10,15,15,20,20,25,25,30,30,35,35,40,40,45,45,...
    50,50,55,55,60,60,65,65,70,70,75,75,80,80,85,85,90,90,95,95,100,100,100];
DatasetO2{2} = [0,0,5,5,10,10,15,15,20,20,25,25,30,30,35,35,40,40,45,45,...
    50,50,55,55,60,60,65,65,70,70,75,75,80,80,85,85,90,90,95,95,100,100,100,100];
DatasetO2{3} = [0,0,5,5,10,10,15,15,20,20,25,25,30,30,35,35,40,40,45,45,...
    50,50,55,55,60,60,65,65,70,70,75,75,80,80,85,85,90,90,95,95,100,100,100];
DatasetO2{4} = [0,0,5,5,10,10,15,15,20,20,25,25,30,30,35,35,40,40,45,45,...
    50,50,55,55,60,60,65,65,70,70,75,75,80,80,85,85,90,90,95,95,100,100];
DatasetO2{5} = [0,0,5,5,10,10,15,15,20,20,25,25,30,30,35,35,40,40,45,45,...
    50,50,55,55,60,60,65,65,70,70,75,75,75,80,80,85,85,90,90,95,95,100,100,100];
DatasetO2{6} = [0,0,5,5,10,10,15,15,20,20,25,25,30,30,30,35,35,40,40,45,...
    45,50,50,55,55,60,60,65,65,70,70,75,75,80,80,85,85,90,90,95,95,100,100,100];

filessize = numel(Datasets); % Getting the size of the total number of files
orr = cell(filessize,1);
orr2 = cell(filessize,1);
out = cell(filessize,1);
out2 = cell(filessize,1);


Q = zeros(filessize,1);
Q2 = zeros(filessize,1);

error = zeros(filessize,1); % Calculating the overall absolute error

methods = ['HSB';'Lab';'XYZ'];
methods = cellstr(methods);

dim1 = ['R';'G';'B'];
dim1 = cellstr(dim1);
dim2 = ['1';'2';'3'];
dim2 = cellstr(dim2);

% best fit subplot grid :
subplotX = 5;
subplotY = filessize / 5;
EsubplotY = floor(subplotY);
if (EsubplotY ~= subplotY)
    subplotY = EsubplotY + 1;
elseif (subplotY < 1)
    subplotY = 1;
end

%%
k = 1; % method used
chan = 1; %
chan2 = 1;
neigh = 5;
% thresh = 0.20;
thresh = 0.15;
disksize = 3;

%% Export data into MAT files for faster use :

% delete(gcp('nocreate')) % shutdown parallel pool
% parpool('threaded_local')

nocrop = 1;
nopictures = 1;

%% Test start
dataset333 = exist('dataset3.mat');

% Setting parameters 
index_dataset = 5;  % 'MT3_R-1/'
index_method = 1;   % 'HSB'
extendCoor = 100;   % 1/2 width of the rectangle (roi)


data = Datasets{index_dataset};
pathf = cat(2,DatasetMain{1}, data);
files = dir(fullfile([pathf '*.bmp']));
O2 = DatasetO2{index_dataset};
filessize = numel(files);

orr = cell(filessize,1);
out = cell(filessize,1);

Q = zeros(filessize,1);
Q_50 = zeros(filessize,1);
Q_75 = zeros(filessize,1);

for index_file = 1:1:filessize
    % Print file path
    sprintf('%s',cat(2,pathf,files(index_file).name))
    
    % Read image from file
    im=imread([pathf files(index_file).name]);
    
    % Crop image to center part (1/3 width of original image)
    im = im(:, size(im,2)/3:2*(size(im,2)/3), :);
    
    % Manually crop the center part
    if (nocrop == 1)
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

        % orr: cropped image. In this place, orr is the same as im
        % because it's already cropped before go inside this nocropfunc()
        % out: cropped colorspace(HSB) converted image
        % Q: average hue value of out
        [orr{index_file},out{index_file},Q(index_file),Q_50(index_file),Q_75(index_file)]=...
            nocropfunc(im,chan,chan2,neigh,thresh,disksize,extendCoor,methods{index_method});
%         figure();
%         imshow(out{index_file});
%         disp(Q(index_file));
        
%     else
%         [orr{index_file},out{index_file},a,a2,a3]=...
%             processfunc(im,chan,chan2,neigh,thresh,disksize,100,methods{index_method});
    end
end

% export :
% filename = cat(2,sprintf('%s',Datasets{index_dataset}),'_result','.mat');
% path = cat(2,'HISTS/',data,methods{index_method},'/');
% link = cat(2,path,filename)
filename = 'MT3_R_2_result.mat';
save(filename,'O2','Q','Q_50','Q_75');
disp("===================Save successfully=======================");

%% Used to delete '.' files
% for k1 = 1:1:size(Datasets, 1)
%     data = Datasets{k1};
%     pathf = cat(2,DatasetMain{1},Datasets{k1});
%     files = dir(fullfile([pathf '*.bmp']));
%     filessize = numel(files);
%     for i=1:1:filessize
%         if(strcmp(files(i).name(1),'.'))
%             delete([pathf files(i).name]); 
%         end
%     end
% end

%%



% % % % Test end


% if (nopictures == 1)
%     if (exist('dataset3.mat') == 0) % only values and O2
%         sprintf('exporting values - takes some time')
%         for k1 = 1:1:size(Datasets,1)
%             data = Datasets{k1};
%             pathf = cat(2,DatasetMain{1},Datasets{k1});
%             files = dir(fullfile([pathf '*.bmp']));
%             O2 = DatasetO2{k1};
%             
%             filessize = numel(files);
%             
%             orr = cell(filessize,1);
%             out = cell(filessize,1);
%             
%             Q = zeros(filessize,1);
%             Q_50 = zeros(filessize,1);
%             Q_75 = zeros(filessize,1);
%             
%             for k2 = 1:1:size(methods,1)
%                 k = k2;
%                 
%                 for k3 = 1:1:1 % size(dim1,1)
%                     chan = k3;
%                     
%                     for k4 = 1:1:1 % size(dim2,1)
%                         chan2 = k4;
%                         
%                         % Loop for training purpose (Q10)
%                         for i=1:1:filessize
%                             if(~strcmp(files(i).name(1),'.'))
%                                 sprintf('%s',cat(2,pathf,files(i).name))
%                                 im=imread([pathf files(i).name]);
%                                 b1 = size(im,2)/3;
%                                 b2 = 2*b1;
%                                 im = im(:,b1:b2,:);
%                                 if (nocrop == 1)
%                                     if (k1 == 3)
%                                         im = im(495:495+201,190:190+201,:); % 190 for 3
%                                     elseif (k1 == 5)
%                                         im = im(495:495+201,215:215+201,:); % 215 for 5
%                                     else
%                                         im = im(495:495+201,235:235+201,:); % 1, 2, 4, 6
%                                     end
%                                     [orr{i},out{i},a,a2,a3]=nocropfunc(im,chan,chan2
%,neigh,thresh,disksize,100,methods{k});
%                                 else
%                                     [orr{i},out{i},a,a2,a3]=processfunc(im,chan,chan2
%,neigh,thresh,disksize,100,methods{k});
%                                 end
%                                 % [a]=boundboxfunc(im); % your image processing
%                                 % title1 = sprintf('O2: %d',O2(i));
%                                 % figure(1); subplot(subplotY,subplotX,i); imshow(orr{i}, []); title(title1);
%                                 % drawnow
%                                 % figure(2); subplot(7,7,i); imshow(out{i}, []); title(title1);
%                                 % drawnow
%                                 a
%                                 Q(i)=a;
%                                 Q_50(i)=a2;
%                                 Q_75(i)=a3;
%                                 % imwrite(orr{i} , cat(2,'IMAGES-RGB\',Datasets{k1},methods{k2},'\',files(i).name));
% %                                 imwrite(out{i} , cat(2,'IMAGES/',Datasets{k1},methods{k2},'/',files(i).name));
%                             end
%                             
%                         end
%                         
%                         if(exist('HISTS')==0)
%                             mkdir('HISTS')
%                         end
%                         if(exist(cat(2,'HISTS/',data,methods{k}))==0)
%                             mkdir('HISTS', cat(2,data,methods{k}))
%                         end
%                         % export :
%                         filename = cat(2,sprintf('%s_%g_%g',methods{k},k3,k4),'.mat');
%                         path = cat(2,'HISTS/',data,methods{k},'/');
%                         link = cat(2,path,filename)
%                         save(link,'O2','Q','Q_50','Q_75');
%                     end
%                 end
%             end
%         end
%     else
%         sprintf('skipping export')
%     end
%     
% else
%     
%     if (exist('rawdata3.mat') == 0)
%         sprintf('exporting all data - takes some time')
%         for k1 = 1:1:size(Datasets,1)
%             data = Datasets{k1};
%             pathf = cat(2,DatasetMain{1},Datasets{k1});
%             files = dir(fullfile([pathf '*.bmp']));
%             O2 = DatasetO2{k1};
%             filessize = numel(files);
%             
%             orr = cell(filessize,1);
%             out = cell(filessize,1);
%             
%             Q = zeros(filessize,1);
%             Q_50 = zeros(filessize,1);
%             Q_75 = zeros(filessize,1);
%             
%             for k2 = 1:1:size(methods,1)
%                 k = k2;
%                 
%                 for k3 = 1:1:1 % size(dim1,1)
%                     chan = k3;
%                     
%                     for k4 = 1:1:1 % size(dim2,1)
%                         chan2 = k4;
%                         
%                         % Loop for training purpose (Q10)
%                         for i=1:1:filessize
%                             im=imread([pathf files(i).name]);
%                             b1 = size(im,2)/3;
%                             b2 = 2*b1;
%                             im = im(:,b1:b2,:);
%                             [orr{i},out{i},a,a2,a3]=processfunc(im,chan,chan2,neigh,thresh,disksize,100,methods{k});
%                             %      [a]=boundboxfunc(im);% your image processing
%                             title1 = sprintf('O2: %d',O2(i));
%                             % figure(1); subplot(subplotY,subplotX,i); imshow(orr{i}, []); title(title1);
%                             % drawnow
%                             figure(2); subplot(7,7,i); imshow(out{i}, []); title(title1);
%                             drawnow
%                             Q(i)=a;
%                             Q_50(i)=a2;
%                             Q_75(i)=a3;
%                             % imwrite(orr{i} , cat(2,'IMAGES-RGB\',Datasets{k1},methods{k2},'\',files(i).name));
%                             imwrite(out{i} , cat(2,'IMAGES\',Datasets{k1},methods{k2},'\',files(i).name));
%                         end
%                         
%                         % export :
%                         filename = cat(2,sprintf('%s_%g_%g',methods{k},k3,k4),'.mat');
%                         path = cat(2,'HISTS\',data,methods{k},'\');
%                         link = cat(2,path,filename)
%                         save(link,'O2','orr','out','Q','Q_50','Q_75');
%                     end
%                 end
%             end
%         end
%     else
%         sprintf('skipping export')
%     end
% end
% 
% %% Import data from .MAT :
% 
% % rawdata3 = cell(2,3,3,3);
% dataset3 = cell(size(Datasets,1),size(methods,1),1,1);
% rawdata3 = cell(size(Datasets,1),size(methods,1),1,1);
% if (nopictures == 1)
%     if (exist('dataset3.mat') == 0)
%         sprintf('Importing dataset into .mat')
%         for k1 = 1:1:size(Datasets,1)
%             
%             for k2 = 1:1:size(methods,1)
%                 
%                 for k3 = 1:1:1 % size(dim1,1)
%                     k4 = 1;
%                     % import :
%                     filename = cat(2,sprintf('%s_%g_%g',methods{k2},k3,k4),'.mat');
%                     path = cat(2,'HISTS\',Datasets{k1},methods{k2},'\');
%                     link = cat(2,path,filename);
%                     filelist = dir(fullfile([path '*.mat']));
%                     for k4 = 1:1:1 % size(dim2,1)
%                         if (exist(link) ~= 0)
%                             filename = cat(2,path,filelist((k3-1)*3+k4).name)
%                             dataset3{k1,k2,k3,k4}(:) = load(filename,'O2','orr','out','Q','Q_50','Q_75');
%                         end
%                     end
%                 end
%             end
%         end
%         save('dataset3.mat','dataset3');
%         load('dataset3.mat','dataset3');
%         sprintf('.mat finished')
%     else
%         sprintf('Loading dataset from .mat')
%         load('dataset3.mat','dataset3');
%     end
% else
%     if (exist('rawdata3.mat') == 0)
%         sprintf('Importing dataset into .mat')
%         for k1 = 1:1:size(Datasets,1)
%             
%             for k2 = 1:1:size(methods,1)
%                 
%                 for k3 = 1:1:1 % size(dim1,1)
%                     k4 = 1;
%                     % import :
%                     filename = cat(2,sprintf('%s_%g_%g',methods{k2},k3,k4),'.mat');
%                     path = cat(2,'HISTS\',Datasets{k1},methods{k2},'\');
%                     link = cat(2,path,filename);
%                     filelist = dir(fullfile([path '*.mat']));
%                     for k4 = 1:1:1 % size(dim2,1)
%                         if (exist(link) ~= 0)
%                             filename = cat(2,path,filelist((k3-1)*3+k4).name)
%                             rawdata3{k1,k2,k3,k4}(:) = load(filename,'O2','orr','out','Q','Q_50','Q_75');
%                         end
%                     end
%                 end
%             end
%         end
%         save('rawdata3.mat','rawdata3');
%         load('rawdata3.mat','rawdata3');
%         sprintf('.mat finished')
%     else
%         sprintf('Loading dataset from .mat')
%         load('rawdata3.mat','rawdata3');
%     end
% end







% %% Plotting all Histograms :
% 
% warning('off')
% 
% % Datasets = ['NEW\';'OLD\'];
% % Datasets = cellstr(Datasets);
% % methods = ['HSB';'Lab';'XYZ'];
% % methods = cellstr(methods);
% % dim1 = ['R';'G';'B'];
% % dim1 = cellstr(dim1);
% % dim2 = ['1';'2';'3'];
% % dim2 = cellstr(dim2);
% 
% close all; clc;
% 
% % Histograms plot :
% fig = 1;
% X = cell(256,1);
% for k1 = 1:1:size(Datasets,1) % Old or New
%     
%     out = rawdata3{k1,1,1,1}.out;
%     
%     sizemax = numel(rawdata3{k1,1,1,1}.O2);
%     % best fit subplot grid :
%     subplotX = 5;
%     subplotY = sizemax / 5;
%     EsubplotY = floor(subplotY);
%     if (EsubplotY ~= subplotY)
%         subplotY = EsubplotY + 1;
%     elseif (subplotY < 1)
%         subplotY = 1;
%     end
%     for k2 = 1:1:size(methods,1) % HSB / L*a*b / XYZ
%         
%         for k3 = 1:1:1 % size(dim1,1) % 1st Dim
%             
%             for k4 = 1:1:1 % size(dim2,1) % 2nd Dim
%                 title2 = sprintf('hist %s %s-%d-%d',Datasets{k1},methods{k2},k3,k4);
%                 s = figure('name',title2);
%                 for k5 = 1:1:numel(rawdata3{k1,k2,k3,k4}.O2)
%                     
%                     [X{k5}] = imhist(rawdata3{k1,k2,k3,k4}.out{k5});
%                     plot(0:255,X{k5}); axis([0 255 0 2500]); title(title2);
%                     hold on
%                     
%                     titleO2 = sprintf('%d',rawdata3{k1,k2,k3,k4}.O2(k5));
%                     %plot(0:255, h);
%                     % subplot(subplotX,subplotY,k5); imhist(rawdata3{k1,k2,k3,k4}.orr{k5});
%                     % title(titleO2);
% 
%                     % titleO2 = sprintf('%g',O2(k5));
%                     % subplot(subplotX,subplotY,k5); imshow(out{k5}, []); title(titleO2);
%                     hold on
%                     drawnow
%                 end
%                 hold off
%                 drawnow
%                 fig = fig + 1;
%             end
%         end
%     end
% end
% 
% endfig = fig;
% %% Algorithm tests :
% 
% close all; clc;
% 
% fig = endfig + 1;
% 
% erase = 0; % 0 or 1 (1 erases current figure)
% 
% STDthresholds = cell(2,3);
% % NEW :
% STDthresholds{1,1} = [0.01 0.05]; % HSB : ok
% STDthresholds{1,2} = [0.55 0.75]; % L*a*b : ok
% STDthresholds{1,3} = [0.01 0.10]; % XYZ : ~ok
% % OLD :
% STDthresholds{2,1} = [0.00 0.01]; % HSB : ~ok
% STDthresholds{2,2} = [0.25 0.55]; % L*a*b : ok
% STDthresholds{2,3} = [0.01 0.02]; % XYZ : ~ok
% 
% % testing each method :
% % testing = 'COOC';
% % testing = 'LBP';
% % testing = 'FFT';
% % testing = 'STD';
% testing = 'NONE';
% % fig = 1;
% 
% 
% for k1 = 1:1:size(Datasets,1) % Old or New
%     O2 = rawdata3{k1,1,1,1}.O2;
%     sizemax = numel(rawdata3{k1,1,1,1}.O2);
%     if (strcmp(testing,'STD') || strcmp(testing,'COOC'))
%         Q2 = zeros(filessize,1);
%     elseif (strcmp(testing,'NONE'))
%         Q2 = zeros(filessize,1);
%         Q2_50 = zeros(filessize,1);
%         Q2_75 = zeros(filessize,1);
%         
%     else
%         Q2 = cell(sizemax,1);
%     end
%     
%     % best fit subplot grid :
%     subplotX = 5;
%     subplotY = sizemax / 5;
%     EsubplotY = floor(subplotY);
%     if (EsubplotY ~= subplotY)
%         subplotY = EsubplotY + 1;
%     elseif (subplotY < 1)
%         subplotY = 1;
%     end
%     
%     for k2 = 1:1:size(methods,1) % HSB / L*a*b / XYZ
%         
%         for k3 = 1:1:1 % 1st Dim
%             
%             for k4 = 1:1:1 % 2nd Dim
%                 
%                 title2 = sprintf('%s %s-%d-%d',Datasets{k1},methods{k2},k3,k4); % testing
%                 
%                 if (strcmp(testing,'COOC'))
% %                     s = figure('name',title2);
%                     s = figure(fig);
%                     Contrast = zeros(1,sizemax);
%                     Correlation = zeros(1,sizemax);
%                     Energy = zeros(1,sizemax);
%                     Homogeneity = zeros(1,sizemax);
%                     
% %                     Contrast2 = zeros(1,sizemax);
% %                     Correlation2 = zeros(1,sizemax);
% %                     Energy2 = zeros(1,sizemax);
% %                     Homogeneity2 = zeros(1,sizemax);
% %                     
% %                     Contrast3 = zeros(1,sizemax);
% %                     Correlation3 = zeros(1,sizemax);
% %                     Energy3 = zeros(1,sizemax);
% %                     Homogeneity3 = zeros(1,sizemax);
%                     
%                     for k5 = 1:1:sizemax
%                         img = rawdata3{k1,k2,k3,k4}.out2{k5};
%                         [Q2(k5),img2] = dataset_tests(img,'COOC',[0 0 0 0]);
%                         titleO2 = sprintf('%d',rawdata3{k1,k2,k3,k4}.O2(k5));
%                         subplot(subplotY,subplotX,k5); imshow(fftshift(fft2(img2(:,:,1))), []); title(titleO2);
%                         drawnow
%                         cooc = graycoprops(img2(:,:,1),'All')
%                         Contrast(k5) = cooc.Contrast;
%                         Correlation(k5) = cooc.Correlation;
%                         Energy(k5) = cooc.Energy;
%                         Homogeneity(k5) = cooc.Homogeneity;
% %                         cooc = graycoprops(img2(:,:,2),'All')
% %                         Contrast2(k5) = cooc.Contrast;
% %                         Correlation2(k5) = cooc.Correlation;
% %                         Energy2(k5) = cooc.Energy;
% %                         Homogeneity2(k5) = cooc.Homogeneity;
% %                         cooc = graycoprops(img2(:,:,3),'All')
% %                         Contrast3(k5) = cooc.Contrast;
% %                         Correlation3(k5) = cooc.Correlation;
% %                         Energy3(k5) = cooc.Energy;
% %                         Homogeneity3(k5) = cooc.Homogeneity;
%                     end
%                     fig = fig + 1;
% %                     figure(fig); plot(rawdata{k1,k2,k3,k4}.O2,Contrast,'r');
% %                     hold on
% %                     plot(rawdata{k1,k2,k3,k4}.O2,Correlation,'b');
% %                     hold on
% %                     plot(rawdata{k1,k2,k3,k4}.O2,Energy,'g');
% %                     hold on
% %                     plot(rawdata{k1,k2,k3,k4}.O2,Homogeneity,'--');
% %                     hold off
% %                     title(title2); legend('Contrast','Correlation','Energy','Homogeneity');
% 
%                     figure(fig); % title(title2);
%                     subplot(2,2,1); plot(rawdata3{k1,k2,k3,k4}.O2,Contrast,'r'); legend('Contrast M0')
%                     subplot(2,2,2); plot(rawdata3{k1,k2,k3,k4}.O2,Correlation,'b'); legend('Correlation M0');
%                     subplot(2,2,3); plot(rawdata3{k1,k2,k3,k4}.O2,Energy,'g'); legend('Energy M0');
%                     subplot(2,2,4); plot(rawdata3{k1,k2,k3,k4}.O2,Homogeneity,'--'); legend('Homogeneity M0');
%                     fig = fig + 1;
%                     
% %                     figure(fig); % title(title2);
% %                     subplot(2,2,1); plot(rawdata{k1,k2,k3,k4}.O2,Contrast2,'r'); legend('Contrast M45')
% %                     subplot(2,2,2); plot(rawdata{k1,k2,k3,k4}.O2,Correlation2,'b'); legend('Correlation M45');
% %                     subplot(2,2,3); plot(rawdata{k1,k2,k3,k4}.O2,Energy2,'g'); legend('Energy M45');
% %                     subplot(2,2,4); plot(rawdata{k1,k2,k3,k4}.O2,Homogeneity2,'--'); legend('Homogeneity M45');
% %                     fig = fig + 1;
% %                     
% %                     figure(fig); % title(title2);
% %                     subplot(2,2,1); plot(rawdata{k1,k2,k3,k4}.O2,Contrast3,'r'); legend('Contrast M90')
% %                     subplot(2,2,2); plot(rawdata{k1,k2,k3,k4}.O2,Correlation3,'b'); legend('Correlation M90');
% %                     subplot(2,2,3); plot(rawdata{k1,k2,k3,k4}.O2,Energy3,'g'); legend('Energy M90');
% %                     subplot(2,2,4); plot(rawdata{k1,k2,k3,k4}.O2,Homogeneity3,'--'); legend('Homogeneity M90');
% %                     fig = fig + 1;
%                     
% %                     figure(fig); plot(rawdata{k1,k2,k3,k4}.O2,Q30,':r^'); title(title2); legend('method 1');
% %                     fig = fig + 1;
%                 elseif (strcmp(testing,'LBP'))
% %                     s = figure('name',title2);
%                     s = figure(fig);
%                     for k5 = 1:1:sizemax
%                         img = rawdata3{k1,k2,k3,k4}.out2{k5};
%                         [Q2{k5},img2] = dataset_tests(img,'LBP',[0 0 0 0]);
%                         titleO2 = sprintf('%d',rawdata3{k1,k2,k3,k4}.O2(k5));
%                         subplot(subplotY,subplotX,k5); imshow(img2, []); title(titleO2);
%                         drawnow
%                     end
%                     fig = fig + 1;
%                     figure(fig);
%                     for k5 = 1:1:sizemax
%                     plot(0:255,X{k5}); title(title2);
%                     hold on
%                     end
%                     hold off
% %                     figure(fig); 
%plot(rawdata{k1,k2,k3,k4}.O2,rawdata{k1,k2,k3,k4}.Q20,'-.go',rawdata{k1,k2,k3,k4}.O2,Q30,':r^'); 
%title(title2); legend('method 1','method 2');
%                     fig = fig + 1;
%                 elseif (strcmp(testing,'FFT'))
%                     for k5 = 1:1:sizemax
%                         img = rawdata3{k1,k2,k3,k4}.out2{k5};
%                         [Q2{k5},img2] = dataset_tests(img,'FFT',[0 0 0 0]);
%                         titleO2 = sprintf('%d',rawdata3{k1,k2,k3,k4}.O2(k5));
%                         s = figure('name',title2);
%                         subplot(subplotY,subplotX,k5); imshow(img2, []); title(titleO2);
%                         drawnow
%                     end
%                     fig = fig + 1;
%                     figure(fig); 
%plot(rawdata3{k1,k2,k3,k4}.O2,rawdata3{k1,k2,k3,k4}.Q20,'-.go',rawdata{k1,k2,k3,k4}.O2,Q30,':r^'); 
%title(title2); legend('method 1','method 2');
%                     fig = fig + 1;
%                 elseif (strcmp(testing,'STD'))
% %                     s = figure('name',title2);
%                     s = figure(fig);
% %                     s = figure(1);
% %                     Q20 = rawdata{k1,k2,k3,k4}.Q10;
%                     for k5 = 1:1:sizemax
%                         img = rawdata3{k1,k2,k3,k4}.out2{k5};
%                         
%                         [Q30(k5),img2] = dataset_tests(img,'STD',
%[3 4 STDthresholds{k1,k2}(1) STDthresholds{k1,k2}(1)]);
%                         titleO2 = sprintf('%d',rawdata3{k1,k2,k3,k4}.O2(k5));
%                         
%                         subplot(subplotY,subplotX,k5); imshow(img2(:,:,3), []); title(titleO2);
% %                         drawnow
%                     end
%                     fig = fig + 1;
%                     figure(fig); plot(rawdata3{k1,k2,k3,k4}.O2,Q30,':r^'); title(title2); legend('2.0x','fit');
%                     hold on
%                     [test,stats,attempts] = fit(O2',Q30,'exp2');
%                     y = test.a*exp(test.b*rawdata3{k1,k2,k3,k4}.O2) + test.c*exp(test.d*rawdata3{k1,k2,k3,k4}.O2);
%                     plot(rawdata3{k1,k2,k3,k4}.O2,y,'--');
%                     hold off
%                     % rawdata{k1,k2,k3,k4}.O2,rawdata{k1,k2,k3,k4}.Q20,'-.go',
%                     fig = fig + 1;
%                     drawnow
%                     pause(0.1)
%                 
%                 elseif (strcmp(testing,'NONE'))
%                     s = figure(fig);
%                     
%                     Q = rawdata3{k1,k2,k3,k4}.Q;
%                     Q_50 = rawdata3{k1,k2,k3,k4}.Q_50;
%                     Q_75 = rawdata3{k1,k2,k3,k4}.Q_75;
% 
%                     plot(rawdata3{k1,k2,k3,k4}.O2,Q,'b');
%                     hold on
%                     plot(rawdata3{k1,k2,k3,k4}.O2,Q_50,'r');
%                     hold on
%                     plot(rawdata3{k1,k2,k3,k4}.O2,Q_75,'g'); title(title2);
%                     legend('avg','0.5','0.75');
%                     hold off
%                     
%                     drawnow
%                     fig = fig + 1;
%                 end
%                 
%             end
%         end
%     end
% end
% 
% %%
% hist = X{1}(1:256);
% sum = zeros(size(hist));
% med = 0;
% ind = 0;
% sum(1) = hist(1);
% 
% for i=2:1:numel(hist)
%     sum(i) = sum(i-1) + hist(i);
% end
% max = sum(numel(hist));
% max = max / 2;
% i = 1;
% while (i<numel(hist) && med<max)
%     med = sum(i);
%     ind = i;
%     i = i + 1;
% end
% up = sum(ind)
% down = sum(ind-1)
% 
% A = up - down
% B = up - A*ind
% xmed = (max - B) / A
% 
