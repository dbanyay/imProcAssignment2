function Y = synthesis(y0,y1,h0)
%1D 2-band synthesis filter bank

hlen = length(h0);

% deriving filters from analysis filter

minusflag = 0;
for i = 1:length(h0)
    if(minusflag)
        g1(i) = - (h0(i));
        minusflag = 0;
    else
        g1(i) = (h0(i));
        minusflag = 1;
    end
end

minusflag = 1;
for i = 1:length(g1)
    if(minusflag)
        g0(i) = - (g1(length(g1)-i+1));
        minusflag = 0;
    else
        g0(i) = (g1(length(g1)-i+1));
        minusflag = 1;
    end
end



% upsampling

y0_up = zeros(1,2*length(y0));
y0_up(1:2:end) = y0';
 

y1_up = zeros(1,2*length(y1));
y1_up(1:2:end) = y1';

% inverse filtering

y0_up = conv(y0_up,g0,'same');

y1_up = conv(y1_up,g1,'same');

% adding up

Y = y0_up+y1_up;


end

