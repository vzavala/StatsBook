% Victor Z
% UW-Madison, 2020
% pdf and cdf of a continuous uniform RV

clc; clear all; close all hidden;

a=-1; b=+1;
x=linspace(-2,2);

figure(1)

% visualize pdf 
subplot(2,2,1)
stairs(x,unifpdf(x,a,b),'-','Color','black','LineWidth',1.5)
grid on
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)

subplot(2,2,2)
% visualize cdf
plot(x,unifcdf(x,a,b),'-','Color','black','LineWidth',1.5)
grid on
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$F(x)$','Interpreter','latex','FontSize',14)
title('')
axis([-2 2 -0.01 1.01])

print -depsc pdfcdfuniformc.eps