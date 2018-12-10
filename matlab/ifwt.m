function im_rest = ifwt(subbands,scale,h0)

%Inverse wavelet transform

row_orig = sqrt(size(subbands, 2))*2;
col_orig = sqrt(size(subbands, 2))*2;

row = row_orig/2^scale;
col = col_orig/2^scale;

for i = 1:scale   
        
    y00 = subbands(1,1:row*row,4-i+1);
    y01 = subbands(2,1:row*row,4-i+1);
    y10 = subbands(3,1:row*row,4-i+1);
    y11 = subbands(4,1:row*row,4-i+1);

    y0 = synthesis(y00,y01,h0);
    y0 = reshape(y0,[], row)';

    y1 = synthesis(y10,y11,h0);
    y1 = reshape(y1,[], row)';

    y0 = reshape(y0,1, []);
    y1 = reshape(y1,1, []);

    im = synthesis(y0,y1,h0);
    
    if(i < scale)
    subbands(1,1:length(im),4-i) = im;        
    
    row = row*2;
    col = col*2;
    
    end

end

im_rest = reshape(im,row_orig, []);
imshow(uint8(im_rest));

end

