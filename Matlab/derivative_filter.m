% Victor Z
% UW-Madison, 2019
% illustrate derivative filter
clc;  clear all; close all hidden; 
format short 

% generate derivative filter
w=[1,0,-1];

% generate signal
N=100;
t=linspace(-10,10,N);
f = normcdf(t);
subplot(2,2,1)
plot(t,f,'black','LineWidth',1.5)
grid on
axis([-10 10 0 1.05])
ylabel('$f(t)$','Interpreter','Latex','FontSize',14)
xlabel('$t$','Interpreter','Latex','FontSize',14)

% perform convolution
phi=conv(f,w,'same')
subplot(2,2,2)
plot(t,phi,'black','LineWidth',1.5)
axis([-10 10 0 0.16])
grid on
ylabel('$f*g(t)$','Interpreter','Latex','FontSize',14)
xlabel('$t$','Interpreter','Latex','FontSize',14)

print -depsc pdf_derivative_filter.eps