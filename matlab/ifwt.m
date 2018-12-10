function im_rest = ifwt(bands,scale,h0)

hlen = length(h0);

y00 = bands(1,:);
y01 = bands(2,:);
y10 = bands(3,:);
y11 = bands(4,:);


%Inverse wavelet transform

y00 = reshape(y00,1,[]);
y00_ext = wextend('1D','sym',y00,hlen-1);
y01 = reshape(y01,1,[]);
y01_ext = wextend('1D','sym',y01,hlen-1);

y10 = reshape(y10,1,[]);
y10_ext = wextend('1D','sym',y10,hlen-1);

y11 = reshape(y11,1,[]);
y11_ext = wextend('1D','sym',y11,hlen-1);

y0 = synthesis(y00_ext,y01_ext,h0);
y0 = reshape(y0,256,[]);


y1 = synthesis(y10_ext,y11_ext,h0);

im = synthesis(y0,y1,h0);
im_rest = reshape(im, 512, []);

imshow(uint8(im_rest));

end

