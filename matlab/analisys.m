function [y0,y1] = analisys(im,h0)
%1D 2-band analisys filter bank

hlen = length(h0)-1;

% deriving the highpass filter

minusflag = 1;
for i = 1:length(h0)
    if(minusflag)
        h1(i) = - (h0(length(h0)-i+1));
        minusflag = 0;
    else
        h1(i) = (h0(length(h0)-i+1));
        minusflag = 1;
    end
end




% filtering

y0 = conv(im,h0,'same');

y1 = conv(im,h1,'same');

% truncating

% y0 = y0(hlen-1:end-hlen);
% y1 = y1(hlen-1:end-hlen);

% downsampling

y0 = y0(1:2:end);

y1 = y1(1:2:end);

end

