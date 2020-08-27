% Victor Z
% UW-Madison, 2020
% use filters on micrograph
% https://www.mathworks.com/help/stats/pca.html

clc
clear all
close all hidden

%%reading and converting the image
inImage=imread('./Data/micrograph.jpg');
inImage=rgb2gray(inImage);
f=double(inImage); 
f=f(10:64,10:64);

figure(1)
subplot(1,3,1)
imshow(uint8(f),[]);
box off

%% apply Sobel filter in vertical direction
g=[1 2 1; 0 0 0; -1 -2 -1]';
fsob=conv2(f,g,'same');
subplot(1,3,2)
imshow(mat2gray(fsob));
box off




%% apply Gaussian filter using convolution
%subplot(2,2,3)
%imshow(mat2gray(f));
%box off

sigma=1;
hsize=length(f);
g = fspecial('gaussian',hsize,sigma);
%fn=conv2(f,g,'same');

fn=ifft2(fft2(f).*fft2(g));
fn=real(fftshift(fn));
subplot(1,3,3)
imshow(mat2gray(fn));
box off

print -depsc micrograph_2Dfilters.eps