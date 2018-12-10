function [im_tf,subbands] = fwt(im, scale, h0)
%Applying direct implemented wavelet filter on 1D input

hlen = length(h0);
row = size(im,1);
col = size(im,2);

subbands = zeros(4,row*col/4, scale);


for i=1:scale
    
    if i == 1
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
    
    subbands(1:4,:,1) = [y00; y01; y10; y11];

    y00 = reshape(y00,row/2, [])';
    y01 = reshape(y01,row/2, [])';
    y10 = reshape(y10,row/2, [])';
    y11 = reshape(y11,row/2, [])';
    
    % truncate images to the original size

    im_tf = [y00 y01; y10 y11];

    
    else
    
    
    row = row/2;
    col = col/2;
    
    im_vect = subbands(1,:,i-1);
    im_vect = im_vect(1:row*col);
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
    
    subbands(1:4,1:length(y00),i) = [y00; y01; y10; y11];

    y00 = reshape(y00,row/2, [])';
    y01 = reshape(y01,row/2, [])';
    y10 = reshape(y10,row/2, [])';
    y11 = reshape(y11,row/2, [])';  
    
    im_tf(1:row,1:col) = [y00 y01; y10 y11]';

    end
end
    im_tf(1:row/2,1:col/2) = im_tf(1:row/2,1:col/2)-128;

    im_tf = im_tf+128;
    
    imshow(uint8(im_tf));
 
end

