function im_rest = ifwt(bands,scale,h0)

y00 = bands(1,:);
y01 = bands(2,:);
y10 = bands(3,:);
y11 = bands(4,:);


%Inverse wavelet transform

y00 = reshape(y00,1,[]);
y01 = reshape(y01,1,[]);
y10 = reshape(y10,1,[]);
y11 = reshape(y11,1,[]);

y0 = synthesis(y00,y01,h0);
y0 = reshape(y0,[], 256)';

y1 = synthesis(y10,y11,h0);
y1 = reshape(y1,[], 256)';

y0 = reshape(y0,1, []);
y1 = reshape(y1,1, []);

im = synthesis(y0,y1,h0);
im_rest = reshape(im, [], 512);

imshow(uint8(im_rest));

end

