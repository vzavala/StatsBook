% Victor Z
% UW-Madison, 2020
% compare exponential RVs

clc; clear all; close all hidden;

% parameter values 
beta=[1,2,4];
w=[0.5,1,1.5,2];
x=linspace(0,4,1000);
n=length(x);

figure(1)
subplot(2,2,1)
for k=1:length(beta)
plot(x,exppdf(x,beta(k)),'black','LineWidth',w(k))
hold on
end
grid on
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
title('')

subplot(2,2,2)
for k=1:length(beta)
plot(x,expcdf(x,beta(k)),'black','LineWidth',w(k))
hold on
end
plot(x,ones(n,1)*0.63,'black--')
grid on
lgd=legend('$\beta=1$','$\beta=2$','$\beta=4$','Interpreter','latex','location','southeast')
lgd.FontSize = 8;
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$F(x)$','Interpreter','latex','FontSize',14)
title('')
print -depsc compareexponentials.eps
