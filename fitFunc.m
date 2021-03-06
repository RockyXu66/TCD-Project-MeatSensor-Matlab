function [settings,errors,f,type] = fitFunc(O2,Q, foldername)

% Get unique O2 and unique average hue value for linear curve
unique_O2 = unique(O2);
unique_avg = zeros(1, 1);
for i = 1:1:numel(unique_O2)
    index_avg = O2==unique_O2(i);
    temp = mean(Q(index_avg));
    unique_avg(i) = temp;
end

%% calculate curve
avg = Q;

[f_exp2, stats_exp2] = fit(O2',avg','exp2');
[f_linear, stats_linear] = fit(unique_O2', unique_avg', 'poly1');
[f_cubic, stats_cubic] = fit(O2',avg','poly3');%,'Normalize','on','Robust','Bisquare');
[f_poly4, status_poly4] = fit(O2', avg', 'poly4');
[f_gauss2, status_gauss2] = fit(O2', avg', 'gauss2');
[f_fou2, status_fou2] = fit(O2', avg', 'fourier2');
 
% % Sum squared error
sse_linear = stats_linear.sse;
sse_exp2 = stats_exp2.sse;
sse_cubic = stats_cubic.sse;
sse_poly4 = status_poly4.sse;
sse_gauss2 = status_gauss2.sse;
sse_fou2 = status_fou2.sse;

settings_linear = [f_linear.p1 f_linear.p2];
settings_exp2 = [f_exp2.a f_exp2.b f_exp2.c f_exp2.d];
settings_cubic = [f_cubic.p1 f_cubic.p2 f_cubic.p3 f_cubic.p4];
settings_poly4 = [f_poly4.p1 f_poly4.p2 f_poly4.p3 f_poly4.p4 f_poly4.p5];
settings_gauss2 = [f_gauss2.a1 f_gauss2.b1 f_gauss2.c1 f_gauss2.a2 f_gauss2.b2 f_gauss2.c2];
settings_fou2 = [f_fou2.a0 f_fou2.a1 f_fou2.b1 f_fou2.a2 f_fou2.b2 f_fou2.w];

%% Save the curve parameters to the .txt file
fid=fopen(cat(2, foldername, '/exp2_parameters.txt'),'w');
fprintf(fid,'a = %d \n',settings_exp2(1));
fprintf(fid,'b = %d \n',settings_exp2(2));
fprintf(fid,'c = %d \n',settings_exp2(3));
fprintf(fid,'d = %d \n',settings_exp2(4));
fclose(fid);

fid=fopen(cat(2, foldername, '/cubic_parameters.txt'),'w');
fprintf(fid,'p1 = %d \n',settings_cubic(1));
fprintf(fid,'p2 = %d \n',settings_cubic(2));
fprintf(fid,'p3 = %d \n',settings_cubic(3));
fprintf(fid,'p4 = %d \n',settings_cubic(4));
fclose(fid);

fid=fopen(cat(2, foldername, '/poly4_parameters.txt'),'w');
fprintf(fid,'p1 = %d \n',settings_poly4(1));
fprintf(fid,'p2 = %d \n',settings_poly4(2));
fprintf(fid,'p3 = %d \n',settings_poly4(3));
fprintf(fid,'p4 = %d \n',settings_poly4(4));
fprintf(fid,'p5 = %d \n',settings_poly4(5));
fclose(fid);

fid=fopen(cat(2, foldername, '/gauss2_parameters.txt'),'w');
fprintf(fid,'a1 = %d \n',settings_gauss2(1));
fprintf(fid,'b1 = %d \n',settings_gauss2(2));
fprintf(fid,'c1 = %d \n',settings_gauss2(3));
fprintf(fid,'a2 = %d \n',settings_gauss2(4));
fprintf(fid,'b2 = %d \n',settings_gauss2(5));
fprintf(fid,'c2 = %d \n',settings_gauss2(6));
fclose(fid);

fid=fopen(cat(2, foldername, '/fou2_parameters.txt'),'w');
fprintf(fid,'a0 = %d \n',settings_fou2(1));
fprintf(fid,'a1 = %d \n',settings_fou2(2));
fprintf(fid,'a2 = %d \n',settings_fou2(3));
fprintf(fid,'b1 = %d \n',settings_fou2(4));
fprintf(fid,'b2 = %d \n',settings_fou2(5));
fprintf(fid,'w = %d \n',settings_fou2(6));
fclose(fid);

errors = min([sse_exp2 sse_cubic sse_linear sse_poly4 sse_gauss2 sse_fou2]);
if errors == sse_exp2
    settings = settings_exp;
    f = f_exp2;
    type = 'exp';
elseif errors == sse_cubic
    settings = settings_cubic;
    f = f_cubic;
    type = 'cubic';
elseif errors == sse_poly4
    settings = settings_poly4;
    f = f_poly4;
    type = 'poly4';
elseif errors == sse_gauss2
    settings = settings_gauss2;
    f = f_gauss2;
    type = 'gauss2';
elseif errors == sse_fou2
    settings = settings_fou2;
    f = f_fou2;
    type = 'fou2';
else
    settings = settings_linear;
    f = f_linear;
    type = 'linear';
end


plot(f_linear, 'blue', O2',avg');
hold on
plot(f_exp2,'green');
hold on
plot(f_cubic,'red');
hold on
plot(f_poly4, 'magenta');
hold on
plot(f_gauss2, 'black');
hold on
plot(f_fou2, 'cyan');
% title(foldername);
xlabel('O2') % x-axis label
ylabel('Q (Mean hue)') % y-axis label
legend('data  | sum of errors', cat(2,'linear   ',num2str(sse_linear)), cat(2,'exp      ',num2str(sse_exp2)),...
    cat(2,'cubic    ',num2str(sse_cubic)), cat(2,'poly4    ',num2str(sse_poly4)),...
    cat(2,'gauss2 ',num2str(sse_gauss2)), cat(2,'fou2      ',num2str(sse_fou2)));
hold off
drawnow

end