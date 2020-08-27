% Victor Z
% UW-Madison, 2020
% use Sobel and Gaussian filters in flow cytometry
% https://www.mathworks.com/help/stats/pca.html

clc
clear all
close all hidden

% load flow cytometry signal
f=load('./Data/flow_cytometry.txt');
f=f(20:50,5:35); % zoom in

c=linspace(0.99,0.0,100)';
C=[c,c,c];
subplot(2,2,1)
imagesc(f)
colormap(C);
axis off

% gaussian filter
sigma=0.5;
hsize=length(f);
g = fspecial('gaussian',hsize,sigma);

% apply filter
fn=conv2(f,g,'same');
subplot(2,2,2)
imagesc(fn);
colormap(C);
axis off

% apply Sobel filter in vertical direction
g=[1 2 1; 0 0 0; -1 -2 -1]';
fnv=conv2(f,g,'same');
subplot(2,2,3)
imagesc(fnv);
colormap(C);
axis off

% apply Sobel filter in horizontal direction
g=[1 2 1; 
    0 0 0; 
    -1 -2 -1];
fnh=conv2(f,g,'same');
subplot(2,2,4)
imagesc(fnh);
colormap(C);
axis off

print -depsc scatter_filter.eps


% apply Gaussian filter using convolution
sigma=0.5;
hsize=length(f);
g = fspecial('gaussian',hsize,sigma);

h=fft2(f).*fft2(g);
fn3=fftshift(ifft2(h));
figure(3)
imagesc(real(fn3));
colormap(C);
axis off

