function [settings,errors,f,type] = fitFunc(O2,Q)

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

% Fit an Exponential curve
f_exp = fit(O2', avg', 'exp2');
% Fit a Cubic Polynomial Specifying Normalize and Robust Options
f_cubic = fit(O2',avg','poly3','Normalize','on','Robust','Bisquare');
% Fit a linear curve
f_linear = fit(unique_O2', unique_avg', 'poly1');


[paras_exp, stats_exp] = fit(O2',avg','exp2');
[paras_cubic, stats_cubic] = fit(O2',avg','poly3','Normalize','on','Robust','Bisquare');
[paras_linear, stats_linear] = fit(unique_O2', unique_avg', 'poly1');
 
% Sum squared error
sse_exp = stats_exp.sse;
sse_cubic = stats_cubic.sse;
sse_linear = stats_linear.sse;
settings_exp = [paras_exp.a paras_exp.b paras_exp.c paras_exp.d];
settings_cubic = [paras_cubic.p1 paras_cubic.p2 paras_cubic.p3 paras_cubic.p4];
settings_linear = [paras_linear.p1 paras_linear.p2];

errors = min([sse_exp sse_cubic sse_linear]);
errors = sse_exp;
if errors == sse_exp
    settings = settings_exp;
    f = f_exp;
    type = 'exp';
elseif errors == sse_cubic
    settings = settings_cubic;
    f = f_cubic;
    type = 'cubic';
else
    settings = settings_linear;
    f = f_linear;
    type = 'linear';
end

plot(f_cubic,'r', O2',avg');
hold on
plot(f_exp,'g');
hold on
plot(f_linear, 'b');
% title(foldername);
xlabel('O2') % x-axis label
ylabel('Q (Mean hue)') % y-axis label
legend('data | sum of errors', cat(2,'cubic ',num2str(sse_cubic)), cat(2,'exp ',num2str(sse_exp)), cat(2,'linear ',num2str(sse_linear)));
hold off
drawnow

end