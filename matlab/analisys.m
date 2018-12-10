function [y0,y1] = analisys(X,h0)
%1D 2-band analisys filter bank
h1 = [-1 1];

% filtering

y0 = conv(h0,X);

y1 = conv(h1,X);

% downsampling

y0 = y0(1:2:end);

y1 = y1(1:2:end);

end

