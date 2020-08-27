% Victor Z
% UW-Madison, 2020
% compare gamma RVs

clc; clear all; close all hidden;

% parameters 
 beta=[1,1,0.5,0.5];
alpha=[1,2,1,2];
w=[0.5,1,1.5,2];
x=linspace(0,4,1000);


figure(1)
subplot(2,2,1)
for k=1:length(beta)
plot(x,gampdf(x,alpha(k),beta(k)),'black','LineWidth',w(k))
hold on
end
grid on
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
lgd=legend('$\beta=1,\alpha=1$','$\beta=1,\alpha=2$','$\beta=1/2,\alpha=1$','$\beta=1/2,\alpha=2$','Interpreter','latex','location','northeast');
lgd.FontSize = 8;

subplot(2,2,2)
for k=1:length(beta)
plot(x,gamcdf(x,alpha(k),beta(k)),'black','LineWidth',w(k))
hold on
end
grid on
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$F(x)$','Interpreter','latex','FontSize',14)
title('')
print -depsc comparegammas.eps
