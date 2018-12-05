clear all
close all

load coeffs.mat

im = imread('images\peppers512x512.tif');

%Change the image into double format which is necessary for the next step,
%i.e. centering all the values around zero

im = double(im);    
im = im - 128;


%% DCT based image compression

%im = 127 * ones(8);    %gives max(dctResultCoeff) = 1016
% im = -128 * ones(8);    %gives min(dctResultCoeff) = -1024



%define the block size 

bSize = 8;

%Crating bSize x bSize DCT Coefficients Matrix A
dctCoeff = dct2coeff(bSize);

%Making 8x8 blocks of image and taking DCT of each block
[numOfBlocks, im_8x8_DCT, newIm_size] = blocks_8x8(im,dctCoeff,bSize);

sizeOfRawTxIm = newIm_size(1)*newIm_size(2);
txt = sprintf('Number of Bytes required to transmit raw image = %d bytes', sizeOfRawTxIm);
disp(txt)

maxDCT = bSize*127;
minDCT = bSize*(-128);

%Quantization by a uniform mid-tread quantizer

stepQ = 2;                                                                  %Step size for uniform midtread quantization
qDCT = stepQ * floor ((im_8x8_DCT/stepQ) + (1/2));
% x_in = minDCT:1:maxDCT;
x_in = -10:0.1:10;
x_out = stepQ * floor ((x_in/stepQ) + (1/2));

figure()
plot(x_in,x_out)


%% FWT based image compression

test = [1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1];

[lb,hb] = liftAnal(test,haar);