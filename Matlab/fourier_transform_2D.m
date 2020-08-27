% Victor Z
% UW-Madison, 2020
% Fourier transform in 2D
% https://www.mathworks.com/help/stats/pca.html

clc
clear all
close all hidden

% create 2D periodic signals
x=linspace(0,10,100);
y=linspace(0,10,100);
[X,Y]=meshgrid(x,y);

% color space
c=linspace(0.99,0.0,100)';
C=[c,c,c];

% create low freq signal
om1=10;
f1=sin(2*pi*om1*(X+Y));

subplot(3,2,3)
s=surf(f1)
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
set(gca,'ZTickLabel',[]);
direction = [1 0 1];
rotate(s,direction,10)
ylabel('$x_2$','Interpreter','Latex','FontSize',14)
xlabel('$x_1$','Interpreter','Latex','FontSize',14)
zlabel('$f_1(x_1,x_2)$','Interpreter','Latex','FontSize',14)

subplot(3,2,4)
imagesc(f1)
colormap(C);
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
set(gca,'ZTickLabel',[]);
ylabel('$x_2$','Interpreter','Latex','FontSize',14)
xlabel('$x_1$','Interpreter','Latex','FontSize',14)

% create high freq signal
om2=60;
f2=sin(2*pi*om2*(X+Y));

subplot(3,2,5)
s=surf(f2)
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
set(gca,'ZTickLabel',[]);
ylabel('$x_2$','Interpreter','Latex','FontSize',14)
xlabel('$x_1$','Interpreter','Latex','FontSize',14)
zlabel('$f_2(x_1,x_2)$','Interpreter','Latex','FontSize',14)
direction = [1 0 1];
rotate(s,direction,10)
subplot(3,2,6)
imagesc(f2)
colormap(C);
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
set(gca,'ZTickLabel',[]);
ylabel('$x_2$','Interpreter','Latex','FontSize',14)
xlabel('$x_1$','Interpreter','Latex','FontSize',14)


% total signal 
f=f1+f2;
subplot(3,2,1)
s=surf(f)
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
set(gca,'ZTickLabel',[]);
direction = [1 0 1];
rotate(s,direction,10)
ylabel('$x_2$','Interpreter','Latex','FontSize',14)
xlabel('$x_1$','Interpreter','Latex','FontSize',14)
zlabel('$f(x_1,x_2)$','Interpreter','Latex','FontSize',14)
subplot(3,2,2)
imagesc(f)
colormap(C);
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
set(gca,'ZTickLabel',[]);
ylabel('$x_2$','Interpreter','Latex','FontSize',14)
xlabel('$x_1$','Interpreter','Latex','FontSize',14)

print -depsc 2dsinetotal.eps

