function [y0,y1] = analisys(X,h0)
%1D 2-band analisys filter bank

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

y0 = conv(X,h0,'same');

y1 = conv(X,h1,'same');

% downsampling

y0 = y0(1:2:end);

y1 = y1(1:2:end);

end

