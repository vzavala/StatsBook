% Victor Z
% UW-Madison, 2020
% compare log normals

clc; clear all; close all hidden;

mu=[0,0,0,1];
sigma=[sqrt(1/5),sqrt(1),sqrt(4),sqrt(1/10)];
w=[0.5,1,1.5,2];
x=linspace(0.001,5,1000);

figure(1)

% generate realizations
S=1000;
rng(0);
X = lognrnd(0,2,S,1);
figure(1)
subplot(2,2,1)
plot(X,'blacko','MarkerFaceColor','w','MarkerSize',4)
xlabel('Outcome $\omega$','Interpreter','latex','FontSize',14)
ylabel('$x_\omega$','Interpreter','latex','FontSize',14)
grid on
subplot(2,2,2)
semilogy(X,'blacko','MarkerFaceColor','w','MarkerSize',4)
xlabel('Outcome $\omega$','Interpreter','latex','FontSize',14)
ylabel('$x_\omega$','Interpreter','latex','FontSize',14)
grid on


% visualize pdf
subplot(2,2,3)
for k=1:length(mu)
plot(x,lognpdf(x,mu(k),sigma(k)),'black-','LineWidth',w(k))
hold on
end
grid on
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
title('')

% visualize cdf
subplot(2,2,4)
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

