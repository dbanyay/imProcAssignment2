function [numOfBlocks, imB_8x8_DCT, im_size] = blocks_8x8(im,dctCoeff,bSize)

%**************************************************************************
%This function takes input grayscale image. Checks the size of image and
%discards any extra rows and columns, if needed, to form complete blocks of
%8x8. It reads 8x8 blocks in the order from left to right, and top to
%bottom in the image. Discarding the extra rows and columns changes the
%size of original image. New size is encoded in im_size. This function also
%returns the total number of blocks formed as numOfBlocks. 
%Formula for numOfBlocks = im_size(1) x im_size(2). 
%Then for each block it takes the 2D DCT and returns as imB_8x8_DCT.
%Size of the matrix imB_8x8_DCT is (bSize x bSize x numOfBlocks).
%**************************************************************************

im_size(1) = size(im,1);                                                    %Number of rows in image im
im_size(2) = size(im,2);                                                    %Number of columns in image im

%Pre-processing to discard last extra rows and columns
im_size(1) = im_size(1) - rem(im_size(1),bSize);
im_size(2) = im_size(2) - rem(im_size(2),bSize);

bRows = (im_size(1)/bSize);                                                     %Number of blocks in rows
bCols = (im_size(2)/bSize);                                                     %Number of blocks in columns

% numOfBlocks = bRows * bCols;
% 
% imB_8x8_DCT = zeros(bSize,bSize,numOfBlocks);                                       %Initializing the DCT Coefficients matrix

numOfBlocks = 1;

%Taking 8x8 blocks of image and calculating the DCT Coefficients
for ro = 1:bRows
    for co = 1:bCols
%       imB_8x8_DCT(1:bSize,1:bSize,numOfBlocks) = dct2(im([8*(ro-1)+1:8*ro],[8*(co-1)+1:8*co]));
      imB_8x8_DCT(1:bSize,1:bSize,numOfBlocks) = dctCoeff*(im([8*(ro-1)+1:8*ro],[8*(co-1)+1:8*co]))*ctranspose(dctCoeff);
      numOfBlocks = numOfBlocks + 1;
    end
end

numOfBlocks = numOfBlocks - 1;

end