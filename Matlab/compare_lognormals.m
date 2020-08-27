% Victor Z
% UW-Madison, 2020
% compare log normals

clc; clear all; close all hidden;

mu=[0,0,0,1];
sigma=[sqrt(1/5),sqrt(1),sqrt(4),sqrt(1/10)];
w=[0.5,1,1.5,2];
x=linspace(0.001,5,1000);

figure(1)

% visualize pdf
subplot(2,2,1)
for k=1:length(mu)
plot(x,lognpdf(x,mu(k),sigma(k)),'black-','LineWidth',w(k))
hold on
end
grid on
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
title('')

% visualize cdf
subplot(2,2,2)
for k=1:length(mu)
plot(x,logncdf(x,mu(k),sigma(k)),'black-','LineWidth',w(k))
hold on
end
grid on
lgd=legend('$\mu=0,\sigma^2=0.2$','$\mu=0,\sigma^2=1$','$\mu=0,\sigma^2=4$',...
'$\mu=1,\sigma^2=0.1$','Interpreter','latex','location','southeast');
lgd.FontSize = 8;
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$F(x)$','Interpreter','latex','FontSize',14)
title('')
print -depsc comparelognormals.eps

