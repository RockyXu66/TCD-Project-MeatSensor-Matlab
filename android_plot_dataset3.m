%% TCD Meat Sensor
% Android plot and fit
clear all; close all; clc;

% load('dataset3.mat');
load('MT3_R_1_result.mat');

warning('off')

fig = 1;
% Datasets = ['MT2_L-3\  ';'MT2_R-4\  ';'MT3_CS-01\';'MT3_R-1\  ';'MT3_R-2\  ';'MT3_R-3\  '];
Datasets = ['MT3_R-1'];
Datasets = cellstr(Datasets);
methods = ['HSB';'Lab';'XYZ'];
methods = cellstr(methods);

%% Dataset3 :
close all

%% Test 

for k1 = 1:1:size(Datasets,1) % Old or New   % =====comment here======
    
    for k2 = 1:1:1%size(methods,1) % HSB / L*a*b / XYZ  % =====comment here======
        
        for k3 = 1:1:1 % 1st Dim
            
            for k4 = 1:1:1 % 2nd Dim
                title2 = sprintf('%s %s-%d-%d',Datasets{k1},methods{k2},k3,k4); % testing
                figure(fig);
                
%                 O2 = dataset3{k1,k2,k3,k4}.O2;
%                 avg = dataset3{k1,k2,k3,k4}.Q;
%                 med = dataset3{k1,k2,k3,k4}.Q_50;
                
                avg = Q;
                med = Q_50;
                
                % avg = flipud(avg)
                % med = flipud(med);
                
                [settings,errors,f,plotv] = fitandimport(O2',avg,'exp2');
%                 % ===go into the function start===
%                 X = O2'; Y = avg;
%                 [test,stats,attempts] = fit(X, Y,'exp2'); % uncomment for more data
%                 
%                 s = figure(fig);
%                 
%                 a = test.a;
%                 b = test.b;
%                 c = test.c;
%                 d = test.d;
%                 
%                 f = str2func('@(a,b,c,d,x) a*exp(b*x) + c*exp(d*x)');
%                                             
%                 % ===go into the function end===

                
                plot(O2,avg,'b');
                hold on
                plot(O2,med,'r');
                hold on
                plot(O2,f(settings(1),settings(2),settings(3),settings(4),O2),'g'); 
                title(title2);
                legend('avg','med','fit');
                hold off
                
                drawnow
                titleFit = sprintf(' a = %.4g,b = %.4g,c = %.4g,d = %.4g',...
                    settings(1),settings(2),settings(3),settings(4));
                title1 = cat(2,title2,titleFit)
                fig = fig + 1;
                
                % Write/save the curve parameters to the .txt file
                fid=fopen('MyFile.txt','w');
                fprintf(fid,'a = %f \n',settings(1));
                fprintf(fid,'b = %f \n',settings(2));
                fprintf(fid,'c = %f \n',settings(3));
                fprintf(fid,'d = %f \n',settings(4));
                fclose(fid);
                
                % Write/save the curve parameters to .mat file
                save('MT3_R_1_para.mat', 'settings');
            end
        end
    end
end



%% multiple sensors plot :
% ==========Comment start===============
% colors = (['r','g','b','--',':','o']);
% for k2 = 1:1:size(methods,1) % HSB only
%     
%     for k1 = 1:1:size(Datasets,1) % Old or New
%         s = figure(fig);
%         
%         for k3 = 1:1:1 % 1st Dim
%             
%             for k4 = 1:1:1 % 2nd Dim
%                 title2 = sprintf('%s %s-%d-%d',Datasets{k1},methods{k2},k3,k4); % testing
%                 
%                 
%                 O2 = dataset3{k1,k2,k3,k4}.O2;
%                 avg = dataset3{k1,k2,k3,k4}.Q;
%                 % med = dataset3{k1,k2,k3,k4}.Q_50;
%                 [settings,errors,f,plotv] = fitandimport(O2',avg,'exp2');
%                 
%                 plot(dataset3{k1,k2,k3,k4}.O2,avg, colors(k1)); grid on
%                 hold on
%                 % plot(dataset3{k1,k2,k3,k4}.O2,med,'r');
%                 hold on
%                 % plot(dataset3{k1,k2,k3,k4}.O2,...
% f(settings(1),settings(2),settings(3),settings(4),dataset3{k1,k2,k3,k4}.O2),'g'); title(title2);
%                 % legend('avg','med','fit');
%                 legend('MT2 L-3','MT2 R-4','MT3 CS-01','MT3 R-1','MT3 R-2','MT3 R-3');
%                 
%                 
%                 drawnow
%                 titleFit = sprintf(' a = %.4g,b = %.4g,c = %.4g,d = %.4g',...
%settings(1),settings(2),settings(3),settings(4));
%                 title1 = cat(2,title2,titleFit)
%             end
%         end
%     end
%     fig = fig + 1;
% end
% hold off
% ==========Comment end===============

%% 

% rep = 19; % replacement value
% 
% O2_1 = dataset3{1,1,1,1}.O2;
% MT2_L3 = dataset3{1,1,1,1}.Q;
% 
% x = find(O2_1 >= 20.9, 1);
% O2_1(x-2) = rep;
% O2_1(x-1) = rep;
% O2_1(x) = 20;
% O2_1(x+1) = 20;
% 
% figure(fig);
% plot(O2_1, MT2_L3,'o-r'); title(sprintf('%s',Datasets{1}));
% 
% O2_2 = dataset3{2,1,1,1}.O2;
% MT2_R4 = dataset3{2,1,1,1}.Q;
% 
% figure(fig);
% plot(O2_2, MT2_R4,'o-r'); title(sprintf('%s',Datasets{2}));
% 
% O2_3 = dataset3{3,1,1,1}.O2;
% MT3_CS01 = dataset3{3,1,1,1}.Q;
% 
% x = find(O2_3 >= 20.9, 1);
% O2_3(x-2) = rep;
% O2_3(x-1) = rep;
% O2_3(x) = 20;
% O2_3(x+1) = 20;
% 
% figure(fig);
% plot(O2_3, MT3_CS01,'o-r'); title(sprintf('%s',Datasets{3}));
% 
% O2_4 = dataset3{4,1,1,1}.O2;
% MT3_R1 = dataset3{4,1,1,1}.Q;
% 
% figure(fig);
% plot(O2_4, MT3_R1,'o-r'); title(sprintf('%s',Datasets{4}));
% 
% O2_5 = dataset3{5,1,1,1}.O2;
% MT3_R2 = dataset3{5,1,1,1}.Q;
% 
% x = find(O2_5 >= 20.9, 1);
% O2_5(x-2) = rep;
% O2_5(x-1) = rep;
% O2_5(x) = 20;
% O2_5(x+1) = 20;
% 
% figure(fig);
% plot(O2_5, MT3_R2,'o-r'); title(sprintf('%s',Datasets{5}));
% 
% O2_6 = dataset3{6,1,1,1}.O2;
% MT3_R3 = dataset3{6,1,1,1}.Q;
% 
% figure(fig);
% plot(O2_6, MT3_R3,'o-r'); title(sprintf('%s',Datasets{6}));


