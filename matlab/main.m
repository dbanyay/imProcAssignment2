clear all
close all

load coeffs.mat

im = imread('baboon512.bmp');


%% DCT based image compression







%% FWT based image compression

test = [1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1];

[appr, det] = lift1D(test,haar);