% Victor Z
% UW-Madison, 2020
% pdf and cdf of a Poisson RV

clc; clear all; close all hidden;

% compare for different lambda
 lambda=[1/2 5 10];
color=["black","black","black"];
marker=["o-","x-","d-"];

x=0:1:20;

figure(1)

% visualize pdf
subplot(2,2,1)
for k=1:length(lambda)
plot(x,poisspdf(x,lambda(k)),marker(k),'MarkerFaceColor','w','MarkerEdgeColor',color(k),'Color',color(k))
hold on
end
grid on
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
lgd=legend('$\lambda=1/2$','$\lambda=5$','$\lambda=10$','Interpreter','latex','location','northeast')
lgd.FontSize = 10;

% visualize cdf
subplot(2,2,2)
for k=1:length(lambda)
plot(x,poisscdf(x,lambda(k)),marker(k),'MarkerFaceColor','w','MarkerEdgeColor',color(k),'Color',color(k))
hold on
end
grid on
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$F(x)$','Interpreter','latex','FontSize',14)
title('')

print -depsc pdfcdfpoisson.eps