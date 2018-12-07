clc
clear all
close all

load coeffs.mat

im1 = imread('images\peppers512x512.tif');
im2 = imread('images\harbour512x512.tif');
im3 = imread('images\boats512x512.tif');
im4 = imread('images\airfield512x512.tif');
im5 = imread('images\bridge512x512.tif');

%Change the image into double format which is necessary for the next step,
%i.e. centering all the values around zero

im1 = double(im1);    
im1 = im1 - 128;
im2 = double(im2);    
im2 = im2 - 128;
im3 = double(im3);    
im3 = im3 - 128;
im4 = double(im4);    
im4 = im4 - 128;
im5 = double(im5);    
im5 = im5 - 128;

%% DCT based image compression

%im = 127 * ones(8);    %gives max(dctResultCoeff) = 1016
% im = -128 * ones(8);    %gives min(dctResultCoeff) = -1024

%define the block size 

bSize = 8;

%Crating bSize x bSize DCT Coefficients Matrix A
dctCoeff = dct2coeff(bSize)

%Making 8x8 blocks of image and taking DCT of each block
[numOfBlocks1, im_8x8_DCT1, newIm_size1] = blocks_8x8(im1,dctCoeff,bSize);
[numOfBlocks2, im_8x8_DCT2, newIm_size2] = blocks_8x8(im2,dctCoeff,bSize);
[numOfBlocks3, im_8x8_DCT3, newIm_size3] = blocks_8x8(im3,dctCoeff,bSize);
[numOfBlocks4, im_8x8_DCT4, newIm_size4] = blocks_8x8(im4,dctCoeff,bSize);
[numOfBlocks5, im_8x8_DCT5, newIm_size5] = blocks_8x8(im5,dctCoeff,bSize);

sizeOfRawTxIm1 = newIm_size1(1)*newIm_size1(2)*8;
txt = sprintf('Number of Bytes required to transmit raw image = %d bits', sizeOfRawTxIm1);
disp(txt)

% maxDCT = bSize*127;
% minDCT = bSize*(-128);

%Quantization by a uniform mid-tread quantizer
%Followed by Block Entropy Encoder

stepQ = (2^2);                                                                  %Step size for uniform midtread quantization

% x_in = minDCT:1:maxDCT;
x_in = -10:0.001:10;
x_out = stepQ * floor ((x_in/stepQ) + (1/2));

% figure()
% plot(x_in,x_out)
% title('Quantizer function with Quantization Step Size = 4')
% xlabel('Input to the quantizer')
% ylabel('Output of the quantizer')


stepC = 1;

for pow = 1:10
    stepQ = 2^(pow-1);
    stepQV(stepC) = stepQ;
    qDCT(:,:,1:numOfBlocks1) = stepQ * floor ((im_8x8_DCT1/stepQ) + (1/2));
    qDCT(:,:,numOfBlocks1+1:numOfBlocks1+numOfBlocks2) = stepQ * floor ((im_8x8_DCT2/stepQ) + (1/2));
    qDCT(:,:,numOfBlocks1+numOfBlocks2+1:numOfBlocks1+numOfBlocks2+numOfBlocks3) = stepQ * floor ((im_8x8_DCT3/stepQ) + (1/2));
    qDCT(:,:,numOfBlocks1+numOfBlocks2+numOfBlocks3+1:numOfBlocks1+numOfBlocks2+numOfBlocks3+numOfBlocks4) = stepQ * floor ((im_8x8_DCT4/stepQ) + (1/2));
    qDCT(:,:,numOfBlocks1+numOfBlocks2+numOfBlocks3+numOfBlocks4+1:numOfBlocks1+numOfBlocks2+numOfBlocks3+numOfBlocks4+numOfBlocks5) = stepQ * floor ((im_8x8_DCT5/stepQ) + (1/2));
    
    im_size = [512 512];
    imrec1 = deblock(qDCT(:,:,1:numOfBlocks1),im_size);
    imrec2 = deblock(qDCT(:,:,numOfBlocks1+1:numOfBlocks1+numOfBlocks2),im_size) ;
    imrec3 = deblock(qDCT(:,:,numOfBlocks1+numOfBlocks2+1:numOfBlocks1+numOfBlocks2+numOfBlocks3),im_size) ;
    imrec4 = deblock(qDCT(:,:,numOfBlocks1+numOfBlocks2+numOfBlocks3+1:numOfBlocks1+numOfBlocks2+numOfBlocks3+numOfBlocks4),im_size) ;
    imrec5 = deblock(qDCT(:,:,numOfBlocks1+numOfBlocks2+numOfBlocks3+numOfBlocks4+1:numOfBlocks1+numOfBlocks2+numOfBlocks3+numOfBlocks4+numOfBlocks5),im_size) ;
    
%     figure()
%     subplot(1,2,1)
%     imshow(uint8(im1(1:32*2,1:32*2)+128))
%     subplot(1,2,2)
%     imshow(uint8(imrec1(1:32*2,1:32*2)+128))
    
    
    
    
    
%     if pow == 1
%         figure()
%         suptitle('Comparison of Original Image with Recovered Image at Quantization step size = 2^0')
%         subplot(1,2,1)
%         imshow(uint8(im1+128))
%         subplot(1,2,2)
%         imshow(uint8(imrec1+128))
%     elseif pow == 10
%         figure()
%         suptitle('Comparison of Original Image with Recovered Image at Quantization step size = 2^9')
%         subplot(1,2,1)
%         imshow(uint8(im1+128))
%         subplot(1,2,2)
%         imshow(uint8(imrec1+128))
%     end

    entrop = zeros(bSize);
    
    error = (imrec1 - im1).^2;
    error = error + (imrec2 - im2).^2;
    error = error + (imrec3 - im3).^2;
    error = error + (imrec4 - im4).^2;
    error = error + (imrec5 - im5).^2;

    mse(stepC) = ((sum(sum(error))))/(5*numel(error));                       %Distortion measure
    
    errorDCT = (qDCT(:,:,1:numOfBlocks1) - im_8x8_DCT1).^2;
    errorDCT = errorDCT + (qDCT(:,:,numOfBlocks1+1:numOfBlocks1+numOfBlocks2) - im_8x8_DCT2).^2;
    errorDCT = errorDCT + (qDCT(:,:,numOfBlocks1+numOfBlocks2+1:numOfBlocks1+numOfBlocks2+numOfBlocks3) - im_8x8_DCT3).^2;
    errorDCT = errorDCT + (qDCT(:,:,numOfBlocks1+numOfBlocks2+numOfBlocks3+1:numOfBlocks1+numOfBlocks2+numOfBlocks3+numOfBlocks4) - im_8x8_DCT4).^2;
    errorDCT = errorDCT + (qDCT(:,:,numOfBlocks1+numOfBlocks2+numOfBlocks3+numOfBlocks4+1:numOfBlocks1+numOfBlocks2+numOfBlocks3+numOfBlocks4+numOfBlocks5) - im_8x8_DCT5).^2;
    mseQDCT(stepC) = (sum(sum(sum(error))))/(5*numel(error));                       %Distortion measure
    

    
    %Calculates entropy of the block
    
    for ro = 1:bSize
        for co = 1:bSize
            roCo = qDCT(ro,co,:);
            entrop(ro,co)= (Entropy(qDCT(ro,co,:)));            
        end
    end
    
    bitsPerBlock(stepC) = sum(sum(entrop)); %/(bSize*bSize);                   %After division by bSize*bSize it becomes bits per pixel
    
    bitsImCoded(stepC) = bitsPerBlock(stepC)*numOfBlocks1;
    sizeRaw(stepC) = sizeOfRawTxIm1;

    
%     error = (qDCT(:,:,1:numOfBlocks1) - im_8x8_DCT1).^2;
%     mse(stepC) = (sum(sum(sum(error))))/numel(error);                       %Distortion measure
    PSNR(stepC) = 10 * log((155^2)/mse(stepC));
    stepC = stepC + 1;
end

figure()
plot(mse,mseQDCT)
xlabel('MSE between the original and the recovered images')
ylabel('MSEbetween the original and the Quantized DCT Coefficients')
title('Relation between distortion, d, and mse of quantized dct coefficients')

% figure()
% plot(log2(stepQV),log(mse))
% xlabel('Distortion')
% ylabel('Mean Squared Error')
% title('Relation between distortion and MSE')

figure()
plot(PSNR,bitsPerBlock,'*-')
xlabel('PSNR [dB]')
ylabel('bit Rate [bits/(8x8 block)]')
title('Relation between PSNR and Bit Rate')

% figure()
% plot(log2(stepQV),bitsPerBlock)
% xlabel('step Size')
% ylabel('bits per pixel')
% title('Relation between Quantization Step Size and Bit Rate')

figure()
plot(PSNR,bitsImCoded/(8*1024),'*-')
xlabel('PSNR [dB]')
ylabel('size [kB]')
title('Relation between Quantization Step Size and Number of Bits required for storing 512x512 Image')
hold on;
plot(PSNR,sizeRaw/(8*1024))
hold off;


%% FWT based image compression

im_orig = im2+128;

scale = 4;

% performing FWT


im_fwt = waveletlegall53(im_orig,scale);

figure

im_fwt_plot = im_fwt; %grey non DC coeff

dc_size = size(im_orig,1) / 2^scale;

im_fwt_plot(1:dc_size,1:dc_size) = im_fwt_plot(1:dc_size,1:dc_size)-128; 

imshow(uint8(im_fwt_plot+128))


% Quantization



for pow = 1:10
    stepQ = 2^(pow-1);
    stepQV(stepC) = stepQ;
    im_fwt_q = stepQ * floor ((im_fwt/stepQ) + (1/2));
end
  
% Restoration

figure
im_res = waveletlegall53(im_fwt,-scale);
subplot(121)
imshow(uint8(im_res))

im_res_q = waveletlegall53(im_fwt_q,-scale);
subplot(122)
imshow(uint8(im_res_q))

% calculate MSE
err = immse(im_res, im_res_q)/numel(im_res);

disp(sprintf('Mean Square Error between quantized and non quantized image: = %d', err));

% calculate entropy

wavelet_entropy = wavelet_ent(im_fwt,scale)

