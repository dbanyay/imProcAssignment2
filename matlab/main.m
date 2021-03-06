clc
clear all
close all

load coeffs.mat
load db8.mat

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
%     txt = sprintf('Original and Recovered images using quantization step size of 2^%d', pow-1);
%     suptitle(txt)
%     subplot(1,2,1)
%     imshow(uint8(im1+128))
%     subplot(1,2,2)
%     imshow(uint8(imrec1+128))
    
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

    quant(stepC) = pow - 1;

    bitsPerBlock(stepC) = sum(sum(entrop)); %/(bSize*bSize);                   %After division by bSize*bSize it becomes bits per pixel
    
    bitsImCoded(stepC) = bitsPerBlock(stepC)*numOfBlocks1;
    sizeRaw(stepC) = sizeOfRawTxIm1;
    PSNR(stepC) = 10 * log((155^2)/mse(stepC));
    stepC = stepC + 1;

end

% figure(1)
% plot(mse,mseQDCT)
% xlabel('MSE between the original and the recovered images')
% ylabel('MSEbetween the original and the Quantized DCT Coefficients')
% title('Relation between distortion, d, and mse of quantized dct coefficients')

% figure()
% plot(log2(stepQV),log(mse))
% xlabel('Distortion')
% ylabel('Mean Squared Error')
% title('Relation between distortion and MSE')

% figure(2)
% plot(PSNR,bitsPerBlock,'*-')
% xlabel('PSNR [dB]')
% ylabel('bit Rate [bits/(8x8 block)]')
% title('Relation between PSNR and Bit Rate')
% 
% figure()
% plot(log2(stepQV),bitsPerBlock)
% xlabel('step Size')
% ylabel('bits per pixel')
% title('Relation between Quantization Step Size and Bit Rate')

figure(10)
plot(quant,bitsImCoded/(8*1024),'k*-')
xlabel('Quantization step size, exponent of 2')
ylabel('size [kB]')
title('Relation between Quantization Step Size and Number of Bits required for storing 512x512 Image')
% hold on;
% plot(quant,sizeRaw/(8*1024))
% hold off;

% figure(4)
% plot(PSNR,bitsImCoded/(8*1024),'*-')
% xlabel('PSNR [dB]')
% ylabel('size [kB]')
% title('Relation between Quantization Step Size and Number of Bits required for storing 512x512 Image')
% hold on;
% % plot(PSNR,sizeRaw/(8*1024))
% % hold off;




%% FWT based image compression

% restore original values
im2 = im2 + 128; % harbour
im3 = im3 + 128; % boat
im1 = im1 + 128; % pepper

h0 = db4;
scale = 4;



% performing FWT

im1_fwt = waveletlegall53(im1,scale);
im2_fwt = waveletlegall53(im2,scale);
im3_fwt = waveletlegall53(im3,scale);
im4_fwt = waveletlegall53(im4,scale);
im5_fwt = waveletlegall53(im5,scale);


% calculate error

stepC = 1;

for pow = 1:10

    stepQ = 2^(pow-1);

    im1_fwt_q = stepQ * floor ((im1_fwt/stepQ) + (1/2));
    im2_fwt_q = stepQ * floor ((im2_fwt/stepQ) + (1/2));
    im3_fwt_q = stepQ * floor ((im3_fwt/stepQ) + (1/2));
    im4_fwt_q = stepQ * floor ((im4_fwt/stepQ) + (1/2));
    im5_fwt_q = stepQ * floor ((im5_fwt/stepQ) + (1/2));
% 
%     im1_res = ifwt(bands1,scale,h0);
%     im2_res = ifwt(bands2,scale,h0);
%     im3_res = ifwt(bands3,scale,h0);

    im1_res = waveletlegall53(im1_fwt_q,-scale);
    im2_res = waveletlegall53(im2_fwt_q,-scale);
    im3_res = waveletlegall53(im3_fwt_q,-scale);
    im4_res = waveletlegall53(im4_fwt_q,-scale);
    im5_res = waveletlegall53(im5_fwt_q,-scale);
    
    if pow == 1
        a2z = 0;
%         figure()
%         subplot(1,2,1)
%         imshow(uint8(im1))
%         subplot(1,2,2)
%         imshow(uint8(im1_res))
    elseif pow == 10
        a2z = 0;
%         figure()
%         subplot(1,2,1)
%         imshow(uint8(im2))
%         subplot(1,2,2)
%         imshow(uint8(im2_res))
    end

    error = immse(im1, im1_res);
    error = error + immse(im2, im2_res);
    error = error + immse(im3, im3_res);
    error = error + immse(im4, im4_res);
    error = error + immse(im5, im5_res);
    
    errorfwt = immse(im1_fwt, im1_fwt_q);
    errorfwt = errorfwt + immse(im2_fwt, im2_fwt_q);
    errorfwt = errorfwt + immse(im3_fwt, im3_fwt_q);
    errorfwt = errorfwt + immse(im4_fwt, im4_fwt_q);
    errorfwt = errorfwt + immse(im5_fwt, im5_fwt_q);
    
    w_ent = wavelet_ent(im1_fwt_q, scale);
    w_ent = w_ent + wavelet_ent(im2_fwt_q, scale);
    w_ent = w_ent + wavelet_ent(im3_fwt_q, scale);
    w_ent = w_ent + wavelet_ent(im4_fwt_q, scale);
    w_ent = w_ent + wavelet_ent(im5_fwt_q, scale);
    
    w_ent = w_ent/5;
    
    wavelet_entropy(stepC) = w_ent;   
    

    msefwt(stepC) = error;                   %Distortion measure  

    mseqFWT(stepC) = errorfwt;          %Distortion measure   

    
    %Distortion measure
    PSNRfwt(stepC) = 10 * log((155^2)/msefwt(stepC));
   
    quant(stepC) = pow - 1;
    stepC = stepC + 1;

end    

figure()
% hold on;
plot(msefwt,mseqFWT)
xlabel('MSE between the original and the recovered images')
ylabel('MSE between the original and the Quantized FWT Coefficients')
title('Relation between distortion, d, and mse of quantized FWT coefficients')
% hold off;

figure()
plot(PSNRfwt,wavelet_entropy/(8*1024),'*-')
xlabel('PSNR [dB]')
ylabel('Average bit rate, weighted by subband size')
title('Relation between PSNR and Bit Rate')

figure(10)
hold on;
plot(quant,wavelet_entropy/(8*1024),'g*-')
xlabel('Quantization step size, exponent of 2')
ylabel('size [kB]')
title('Relation between Quantization Step Size and Number of Bits required for storing 512x512 Image')
hold off;
legend('DCT Based Image Compression','FWT Based Image Compression');
