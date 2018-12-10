function Y = synthesis(y0,y1,h0)
%1D 2-band synthesis filter bank
h1 = [1 -1];

% upsampling


y0_up = zeros(1,length(y0)+length(h0)+1);
y0_up(1:2:end) = y0;
 

y1_up = zeros(1,length(y1)+length(h1)+1);
y1_up(1:2:end) = y1;

% inverse filtering

y0_up = 0.5*(conv(h0,y0_up));

y1_up = 0.5*(conv(h1,y1_up));

% adding up

Y = y0_up+y1_up;

% truncate

Y = Y(length(h0):end-length(h0)+1);


end

