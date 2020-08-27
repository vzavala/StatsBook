% Victor Z
% UW-Madison, 2019
% confidence region for mixing problem

clc; clear all; close all hidden;

mu=30
sig=1

% prob level
alpha=0.1

% the quantile for N(0,1)
z = norminv(1-alpha/2,0,1)

% confirm P(-z<=Z<=z)=F(z)-F(-z) is 1-alpha
P=normcdf(z,0,1)-normcdf(-z,0,1)

% the confidence internal for N(mu,sig) is
xL=mu-z*sig
xU=mu+z*sig

figure(1)
yy=linspace(0,0.5,100);
L=linspace(xL,xL,100);
U=linspace(xU,xU,100);
x=linspace(mu-5*sig,mu+5*sig);
plot(x,normpdf(x,mu,sig),'blue','LineWidth',1.5)
grid on
xlabel('$x$','Interpreter','latex')
ylabel('$f(x)$','Interpreter','latex')
title('')
hold on
plot(L,yy,'black','LineWidth',1.5)
plot(U,yy,'black','LineWidth',1.5)
print -depsc conf_mixing.eps



