function [x_estimated] = computeO2Func(y_estimated, parameters)

a = parameters(1);
b = parameters(2);
c = parameters(3);
d = parameters(4);

N = 100;
x_estimated = 0; %﻿computed oxygen concentration

y_experimental = zeros(1,100);
for j = 2:1:100
    y_experimental(1, j-1) = a * exp(b*j) + c * exp(d*j);    
end

slope_experimental = zeros(1,99);
for p = 1:1:99
   slope_experimental(1,p) =  y_experimental(1, p+1) - y_experimental(1, p);
end

% Find edge values for curve
y_max_experimental = y_experimental(1,1);
y_min_experimental = y_experimental(1,1);
for i = 2:1:100
    if(y_experimental(1,i)>y_max_experimental)
        y_max_experimental = y_experimental(1, i);
    elseif(y_experimental(1,i)<y_min_experimental)
        y_min_experimental = y_experimental(1,i);
    end
end


if(y_estimated > y_max_experimental)
    x_estimated = 0;
elseif(y_estimated < y_min_experimental)
    x_estimated = 100;
else
    for i = 2:1:100
       if(y_estimated < y_experimental(1, i-1) && y_estimated > y_experimental(1, i))
           x_estimated = i + ((y_estimated - y_experimental(1,i))/slope_experimental(1,i-1));
       end
    end
end


end