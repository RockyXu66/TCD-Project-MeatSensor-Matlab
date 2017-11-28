%% TCD Meat Sensor
% Evaluate curve errors
clear all; close all; clc;
format short g

foldername = 'MT2_L-3';

load(cat(2,foldername, '/', foldername, '_para.mat'));
% load('MT3_R-1/MT3_R-1_para.mat');
load(cat(2,foldername, '/', foldername, '_Qresult.mat'));
load dataset3.mat

close all;
Q = Q';
original_O2 = xlsread(cat(2,foldername,'/',foldername,'_O2.xlsx'));
estimated_O2 = zeros(size(Q,1), 1);
abs_error = zeros(size(Q,1), 1);
for i = 1:1:size(Q,1)
   estimated_O2(i, 1) = computeO2Func(Q(i,1), settings);
   abs_error(i, 1) = abs(original_O2(i,1) - estimated_O2(i,1));
end

T_all = table(original_O2, estimated_O2, abs_error);

t_original_O2 = zeros(21,1);
t_estimated_O2 = zeros(21,1);
t_abs_error = zeros(21,1);
for i = 1:1:(size(Q,1)/2)
   t_original_O2(i,1) = (original_O2(i*2-1,1) + original_O2(i*2,1))/2;
   t_estimated_O2(i,1) = (estimated_O2(i*2-1,1) + estimated_O2(i*2,1))/2;
   t_abs_error(i,1) = (abs_error(i*2-1,1) + abs_error(i*2,1))/2;
end

T = table(t_original_O2, t_estimated_O2, t_abs_error);

% MT3_R_2_Q = dataset3{4,1,1,1}.Q;
average_error = mean(t_abs_error);