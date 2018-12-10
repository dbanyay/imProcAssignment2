function [im_tf,bands] = fwt(im, scale, h0)
%Applying direct implemented wavelet filter on 1D input

hlen = length(h0);
row = size(im,1);
col = size(im,2);


for i=1:scale
    % use 1D filtering row-wise
    im_vect = reshape(im,1,[]);
    % extend image
    im_ext = wextend('1D','sym',im_vect,hlen-1);
    
    
    [y0,y1] = analisys(im_ext, h0);


    y0 = reshape(y0,[], col)';
    y1 = reshape(y1,[], col)';


    % 1D filtering column-wise, using the outputs of the first division
    y0 = reshape(y0,1, []);
    y0_ext = wextend('1D','sym',y0,hlen-1);
    y1 = reshape(y1,1, []);
    y1_ext = wextend('1D','sym',y1,hlen-1);

    [y00,y01] = analisys(y0_ext, h0);
    [y10,y11] = analisys(y1_ext, h0);
    
    bands = [y00; y01; y10; y11];

    y00 = reshape(y00,row/2, [])';
    y01 = reshape(y01,row/2, [])';
    y10 = reshape(y10,row/2, [])';
    y11 = reshape(y11,row/2, [])';
    
    % truncate images to the original size

    im_tf = [y00 y01; y10 y11];
    imshow(uint8(im_tf));
end
end

