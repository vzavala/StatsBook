% Victor Z
% UW-Madison, 2020
% use Sobel and Gaussian filters

clc
clear all
close all hidden

%%reading and converting the image
inImage=imread('./Data/devilslake.jpeg');
f=rgb2gray(inImage);

f = imresize(f,0.2);
f = f(1:605,1:605);

size(f)

figure(1)
imshow(uint8(f),[]);
box off

imwrite(f, './Data/devilslakeg.jpg');