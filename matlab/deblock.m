function im_deblock = deblock(blocks,im_size)
%perform inverse DCT and rebulid the image from the blocks

im_deblock = zeros(im_size);
bRows = (im_size(1)/8);                                                     
bCols = (im_size(2)/8);

% Perform inverse DCT on blocks and rebuild image
numOfBlocks = 1;

for ro = 1:bRows
    for co = 1:bCols
      im_deblock(8*(ro-1)+1:8*ro,8*(co-1)+1:8*co) = idct2(blocks(:,:,numOfBlocks));
      numOfBlocks = numOfBlocks + 1;
    end
end

end

