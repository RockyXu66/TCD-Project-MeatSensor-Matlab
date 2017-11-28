function [settings,errors,f,plotv] = fitandimport(X,Y,ftype)

[test,stats,attempts] = fit(X,Y,ftype); % uncomment for more data

indexmax = find(max(Y) == Y);
xmax = X(indexmax);
ymax = Y(indexmax);
xmax2 = X(indexmax);
ymax2 = Y(indexmax);

plotv = [xmax, ymax,xmax2, ymax2];

if (strcmp(ftype,'exp2'))
    f = str2func('@(a,b,c,d,x) a*exp(b*x) + c*exp(d*x)');
end

a = test.a;
b = test.b;
c = test.c;
d = test.d;

settings(1:4) = [a b c d];

sse = stats.sse;
rsquare = stats.rsquare;
dfe = stats.dfe;
adjrsquare = stats.adjrsquare;
rmse = stats.rmse;

errors(1:5) = [sse rsquare dfe adjrsquare rmse];

% str2func('a*(x-b)^n');

end